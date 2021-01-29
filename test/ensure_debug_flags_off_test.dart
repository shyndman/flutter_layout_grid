import 'package:flutter_layout_grid/src/rendering/debug.dart';
import 'package:flutter_test/flutter_test.dart';

// A bunch of sanity checks to make sure we don't release anything with debug
// features turned on.
void main() {
  test('Ensure that debug printing is turned off', () {
    expect(debugPrintGridLayout, false);
  });

  test('Ensure that debug overflow printing is turned off', () {
    expect(debugPrintUnplacedChildren, false);
  });
}
