import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/history_repository_impl.dart';
import '../../data/repositories/pdf_repository_impl.dart';
import '../../domain/entities/conversion_result.dart';
import '../../domain/entities/conversion_settings.dart';
import '../../domain/entities/history_entry.dart';
import '../../domain/entities/pdf_file.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/repositories/pdf_repository.dart';
import '../../domain/usecases/convert_pdf_usecase.dart';
import '../../domain/usecases/pick_pdf_usecase.dart';
import '../../services/file_service.dart';
import '../../services/history_storage_service.dart';
import '../../services/pdf_conversion_service.dart';
import '../../services/share_service.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final fileServiceProvider = Provider((ref) => FileService());
final conversionServiceProvider = Provider((ref) => PdfConversionService());
final shareServiceProvider = Provider((ref) => ShareService());
final historyStorageProvider = Provider((ref) => HistoryStorageService());

final pdfRepositoryProvider = Provider<PdfRepository>((ref) => PdfRepositoryImpl(
      fileService: ref.read(fileServiceProvider),
      conversionService: ref.read(conversionServiceProvider),
      shareService: ref.read(shareServiceProvider),
    ));

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepositoryImpl(ref.read(historyStorageProvider)),
);

final pickPdfUseCaseProvider = Provider((ref) => PickPdfUseCase(ref.read(pdfRepositoryProvider)));
final convertPdfUseCaseProvider = Provider((ref) => ConvertPdfUseCase(ref.read(pdfRepositoryProvider)));

class AppState {
  const AppState({
    this.pdf,
    this.settings = ConversionSettings.defaults,
    this.result,
    this.logs = const [],
    this.progress = 0,
    this.isConverting = false,
    this.error,
    this.previewPage,
  });

  final PdfFile? pdf;
  final ConversionSettings settings;
  final ConversionResult? result;
  final List<String> logs;
  final double progress;
  final bool isConverting;
  final String? error;
  final int? previewPage;

  AppState copyWith({
    PdfFile? pdf,
    ConversionSettings? settings,
    ConversionResult? result,
    List<String>? logs,
    double? progress,
    bool? isConverting,
    String? error,
    int? previewPage,
  }) {
    return AppState(
      pdf: pdf ?? this.pdf,
      settings: settings ?? this.settings,
      result: result ?? this.result,
      logs: logs ?? this.logs,
      progress: progress ?? this.progress,
      isConverting: isConverting ?? this.isConverting,
      error: error,
      previewPage: previewPage ?? this.previewPage,
    );
  }
}

class AppController extends StateNotifier<AppState> {
  AppController(this.ref) : super(const AppState());
  final Ref ref;

  Future<void> pickPdf() async {
    try {
      final pdf = await ref.read(pickPdfUseCaseProvider).call();
      state = state.copyWith(pdf: pdf, error: null, result: null, logs: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void updateSettings(ConversionSettings settings) {
    state = state.copyWith(settings: settings);
  }

  Future<void> convert() async {
    if (state.pdf == null) return;
    final useCase = ref.read(convertPdfUseCaseProvider);
    state = state.copyWith(isConverting: true, progress: 0, logs: [], error: null);
    try {
      final result = await useCase.call(
        file: state.pdf!,
        settings: state.settings,
        onProgress: (done, total, message) {
          final updatedLogs = [...state.logs, message];
          state = state.copyWith(
            logs: updatedLogs,
            progress: total == 0 ? 0 : done / total,
          );
        },
      );

      await ref.read(historyRepositoryProvider).addEntry(
            HistoryEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              sourceName: state.pdf!.name,
              totalPages: result.outputPaths.length,
              format: state.settings.imageFormat.name,
              createdAt: DateTime.now(),
              outputDirectory: result.outputDir,
            ),
          );
      state = state.copyWith(isConverting: false, result: result, progress: 1);
    } catch (e) {
      state = state.copyWith(isConverting: false, error: e.toString());
    }
  }

  Future<List<HistoryEntry>> history() => ref.read(historyRepositoryProvider).getEntries();

  Future<void> shareResultFiles() async {
    final result = state.result;
    if (result == null) return;
    await ref.read(pdfRepositoryProvider).shareFiles(result.outputPaths);
  }

  Future<void> shareZip() async {
    final zip = state.result?.zipPath;
    if (zip == null) return;
    await ref.read(pdfRepositoryProvider).shareZip(zip);
  }
}

final appControllerProvider = StateNotifierProvider<AppController, AppState>((ref) => AppController(ref));
