import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../core/error/app_exception.dart';
import '../domain/entities/conversion_result.dart';
import '../domain/entities/conversion_settings.dart';
import '../domain/entities/pdf_file.dart';
import '../utils/page_range_parser.dart';

class PdfConversionService {
  Future<ConversionResult> convert({
    required PdfFile file,
    required ConversionSettings settings,
    required void Function(int done, int total, String message) onProgress,
  }) async {
    final logs = <String>[];
    final document = await PdfDocument.openFile(file.path);

    try {
      final totalPages = document.pagesCount;
      final targetPages = settings.convertAll
          ? {for (int i = 1; i <= totalPages; i++) i}
          : parsePageRanges(settings.pageRanges, totalPages);

      final baseDir = await getApplicationDocumentsDirectory();
      final outputDir = Directory('${baseDir.path}/exports/${DateTime.now().millisecondsSinceEpoch}');
      await outputDir.create(recursive: true);
      final paths = <String>[];

      int done = 0;
      for (final pageIndex in targetPages.toList()..sort()) {
        onProgress(done, targetPages.length, 'Rendering page $pageIndex');
        logs.add('Render page $pageIndex');
        final page = await document.getPage(pageIndex);
        final scale = settings.dpi / 72;
        final rendered = await page.render(
          width: page.width * scale,
          height: page.height * scale,
          format: PdfPageImageFormat.png,
        );
        await page.close();

        if (rendered == null || rendered.bytes.isEmpty) {
          throw AppException('Failed to render page $pageIndex');
        }

        final output = await Isolate.run(
          () => _processImage(
            bytes: rendered.bytes,
            settings: settings,
            fileName: _makeFilename(file.name, pageIndex, settings.imageFormat),
            outputDir: outputDir.path,
          ),
        );
        paths.add(output);

        done++;
        onProgress(done, targetPages.length, 'Finished page $pageIndex');
      }

      String? zipPath;
      if (paths.length > 1) {
        final encoder = ZipFileEncoder();
        zipPath = '${outputDir.path}/images.zip';
        encoder.create(zipPath);
        for (final path in paths) {
          encoder.addFile(File(path));
        }
        encoder.close();
        logs.add('ZIP created at $zipPath');
      }

      return ConversionResult(outputPaths: paths, outputDir: outputDir.path, zipPath: zipPath, log: logs);
    } finally {
      await document.close();
    }
  }

  static String _makeFilename(String source, int page, ImageFormat format) {
    final clean = source.replaceAll('.pdf', '').replaceAll(' ', '_');
    return '${clean}_page_${page.toString().padLeft(3, '0')}.${format.name}';
  }

  static String _processImage({
    required Uint8List bytes,
    required ConversionSettings settings,
    required String fileName,
    required String outputDir,
  }) {
    img.Image? src = img.decodeImage(bytes);
    if (src == null) {
      throw AppException('Could not decode rendered image bytes.');
    }

    if (settings.grayscale) {
      src = img.grayscale(src);
    }

    if (settings.watermark.trim().isNotEmpty) {
      img.drawString(
        src,
        settings.watermark,
        x: src.width ~/ 12,
        y: src.height - (src.height ~/ 8),
        color: img.ColorRgba8(255, 255, 255, (255 * settings.watermarkOpacity).toInt()),
      );
    }

    late List<int> encoded;
    switch (settings.imageFormat) {
      case ImageFormat.png:
        encoded = img.encodePng(src, level: settings.optimizeCompression ? 9 : 3);
        break;
      case ImageFormat.jpg:
        encoded = img.encodeJpg(src, quality: settings.quality);
        break;
      case ImageFormat.webp:
        encoded = img.encodeWebP(src, quality: settings.quality);
        break;
    }

    final path = '$outputDir/$fileName';
    File(path).writeAsBytesSync(encoded, flush: true);
    return path;
  }
}
