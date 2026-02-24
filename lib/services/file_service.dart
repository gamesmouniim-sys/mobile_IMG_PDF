import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';

import '../core/error/app_exception.dart';
import '../domain/entities/pdf_file.dart';
import '../utils/formatters.dart';

class FileService {
  static const maxBytes = 100 * 1024 * 1024;

  Future<PdfFile> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
    );

    if (result == null || result.files.single.path == null) {
      throw AppException('No file selected');
    }

    final path = result.files.single.path!;
    if (extensionFromPath(path) != 'pdf') {
      throw AppException('Only PDF files are allowed');
    }

    final file = File(path);
    final size = await file.length();
    if (size > maxBytes) {
      throw AppException('File too large. Max allowed is 100MB.');
    }

    final doc = await PdfDocument.openFile(path);
    final pages = doc.pagesCount;
    await doc.close();

    return PdfFile(
      path: path,
      name: result.files.single.name,
      sizeBytes: size,
      pages: pages,
    );
  }
}
