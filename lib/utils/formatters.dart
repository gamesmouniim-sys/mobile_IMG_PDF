import 'dart:io';

String formatBytes(int bytes) {
  const suffixes = ['B', 'KB', 'MB', 'GB'];
  double value = bytes.toDouble();
  int i = 0;
  while (value >= 1024 && i < suffixes.length - 1) {
    value /= 1024;
    i++;
  }
  return '${value.toStringAsFixed(i == 0 ? 0 : 2)} ${suffixes[i]}';
}

String extensionFromPath(String path) {
  return path.split(Platform.pathSeparator).last.split('.').last.toLowerCase();
}
