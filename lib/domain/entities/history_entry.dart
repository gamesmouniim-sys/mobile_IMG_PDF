class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.sourceName,
    required this.totalPages,
    required this.format,
    required this.createdAt,
    required this.outputDirectory,
  });

  final String id;
  final String sourceName;
  final int totalPages;
  final String format;
  final DateTime createdAt;
  final String outputDirectory;
}
