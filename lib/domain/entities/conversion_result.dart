class ConversionResult {
  const ConversionResult({
    required this.outputPaths,
    required this.outputDir,
    this.zipPath,
    required this.log,
  });

  final List<String> outputPaths;
  final String outputDir;
  final String? zipPath;
  final List<String> log;
}
