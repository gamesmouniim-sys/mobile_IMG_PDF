import '../entities/conversion_result.dart';
import '../entities/conversion_settings.dart';
import '../entities/pdf_file.dart';

abstract class PdfRepository {
  Future<PdfFile> pickPdf();
  Future<ConversionResult> convertPdf({
    required PdfFile file,
    required ConversionSettings settings,
    required void Function(int done, int total, String message) onProgress,
  });
  Future<void> shareFiles(List<String> paths);
  Future<void> shareZip(String path);
}
