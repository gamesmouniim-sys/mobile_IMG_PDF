import '../entities/pdf_file.dart';
import '../repositories/pdf_repository.dart';

class PickPdfUseCase {
  const PickPdfUseCase(this.repository);
  final PdfRepository repository;

  Future<PdfFile> call() => repository.pickPdf();
}
