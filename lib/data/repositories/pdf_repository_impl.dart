import '../../domain/entities/conversion_result.dart';
import '../../domain/entities/conversion_settings.dart';
import '../../domain/entities/pdf_file.dart';
import '../../domain/repositories/pdf_repository.dart';
import '../../services/file_service.dart';
import '../../services/pdf_conversion_service.dart';
import '../../services/share_service.dart';

class PdfRepositoryImpl implements PdfRepository {
  PdfRepositoryImpl({
    required FileService fileService,
    required PdfConversionService conversionService,
    required ShareService shareService,
  })  : _fileService = fileService,
        _conversionService = conversionService,
        _shareService = shareService;

  final FileService _fileService;
  final PdfConversionService _conversionService;
  final ShareService _shareService;

  @override
  Future<PdfFile> pickPdf() => _fileService.pickPdf();

  @override
  Future<ConversionResult> convertPdf({
    required PdfFile file,
    required ConversionSettings settings,
    required void Function(int done, int total, String message) onProgress,
  }) {
    return _conversionService.convert(file: file, settings: settings, onProgress: onProgress);
  }

  @override
  Future<void> shareFiles(List<String> paths) => _shareService.shareFiles(paths);

  @override
  Future<void> shareZip(String path) => _shareService.shareZip(path);
}
