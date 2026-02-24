import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_to_image_premium/utils/page_range_parser.dart';

void main() {
  test('parses mixed ranges', () {
    final result = parsePageRanges('1-3,5,7-8', 10);
    expect(result, {1, 2, 3, 5, 7, 8});
  });
}
