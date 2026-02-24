import '../../domain/entities/history_entry.dart';

class HistoryEntryModel extends HistoryEntry {
  const HistoryEntryModel({
    required super.id,
    required super.sourceName,
    required super.totalPages,
    required super.format,
    required super.createdAt,
    required super.outputDirectory,
  });

  factory HistoryEntryModel.fromEntity(HistoryEntry e) => HistoryEntryModel(
        id: e.id,
        sourceName: e.sourceName,
        totalPages: e.totalPages,
        format: e.format,
        createdAt: e.createdAt,
        outputDirectory: e.outputDirectory,
      );

  factory HistoryEntryModel.fromJson(Map<String, dynamic> json) => HistoryEntryModel(
        id: json['id'] as String,
        sourceName: json['sourceName'] as String,
        totalPages: json['totalPages'] as int,
        format: json['format'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        outputDirectory: json['outputDirectory'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceName': sourceName,
        'totalPages': totalPages,
        'format': format,
        'createdAt': createdAt.toIso8601String(),
        'outputDirectory': outputDirectory,
      };
}
