import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../data/models/history_entry_model.dart';

class HistoryStorageService {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/conversion_history.json');
  }

  Future<List<HistoryEntryModel>> getAll() async {
    final file = await _file();
    if (!await file.exists()) return [];
    final data = await file.readAsString();
    if (data.trim().isEmpty) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map((e) => HistoryEntryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> add(HistoryEntryModel entry) async {
    final file = await _file();
    final all = await getAll();
    all.insert(0, entry);
    await file.writeAsString(jsonEncode(all.map((e) => e.toJson()).toList()));
  }
}
