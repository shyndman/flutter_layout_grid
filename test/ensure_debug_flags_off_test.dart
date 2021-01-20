import 'package:flutter_layout_grid/src/rendering/debug.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Just a sanity check to make sure we don't release anything with debug
  // printing turned on.
  test('Ensure that debug printing is turned off', () {
    expect(debugPrintGridLayout, false);
  });
}
