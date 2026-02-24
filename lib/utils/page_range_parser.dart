Set<int> parsePageRanges(String input, int totalPages) {
  if (input.trim().isEmpty) {
    return {for (int i = 1; i <= totalPages; i++) i};
  }

  final pages = <int>{};
  final parts = input.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);

  for (final part in parts) {
    if (part.contains('-')) {
      final rangeParts = part.split('-').map((e) => int.tryParse(e.trim())).toList();
      if (rangeParts.length != 2 || rangeParts.any((e) => e == null)) {
        throw FormatException('Invalid range: $part');
      }
      var start = rangeParts.first!;
      var end = rangeParts.last!;
      if (start > end) {
        final temp = start;
        start = end;
        end = temp;
      }
      for (int p = start; p <= end; p++) {
        if (p >= 1 && p <= totalPages) pages.add(p);
      }
    } else {
      final value = int.tryParse(part);
      if (value == null) throw FormatException('Invalid page: $part');
      if (value >= 1 && value <= totalPages) pages.add(value);
    }
  }

  if (pages.isEmpty) {
    throw FormatException('No valid pages in range.');
  }

  return pages;
}
