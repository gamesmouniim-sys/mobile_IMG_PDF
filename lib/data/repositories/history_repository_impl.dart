import '../../data/models/history_entry_model.dart';
import '../../domain/entities/history_entry.dart';
import '../../domain/repositories/history_repository.dart';
import '../../services/history_storage_service.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._storage);
  final HistoryStorageService _storage;

  @override
  Future<void> addEntry(HistoryEntry entry) {
    return _storage.add(HistoryEntryModel.fromEntity(entry));
  }

  @override
  Future<List<HistoryEntry>> getEntries() => _storage.getAll();
}
