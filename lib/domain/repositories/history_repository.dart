import '../entities/history_entry.dart';

abstract class HistoryRepository {
  Future<void> addEntry(HistoryEntry entry);
  Future<List<HistoryEntry>> getEntries();
}
