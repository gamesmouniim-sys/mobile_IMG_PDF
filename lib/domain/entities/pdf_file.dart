class PdfFile {
  const PdfFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.pages,
  });

  final String path;
  final String name;
  final int sizeBytes;
  final int pages;
}
