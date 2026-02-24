import '../entities/conversion_result.dart';
import '../entities/conversion_settings.dart';
import '../entities/pdf_file.dart';
import '../repositories/pdf_repository.dart';

class ConvertPdfUseCase {
  const ConvertPdfUseCase(this.repository);
  final PdfRepository repository;

  Future<ConversionResult> call({
    required PdfFile file,
    required ConversionSettings settings,
    required void Function(int done, int total, String message) onProgress,
  }) {
    return repository.convertPdf(file: file, settings: settings, onProgress: onProgress);
  }
}
