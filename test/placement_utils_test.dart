import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  group('template area parsing', () {
    test('not sure yet', () {
      final templateAreas = gridTemplateAreas([
        'a  a  a a',
        'a  a  a a',
        'a  a  a a',
        'cc cc . .',
        'b  b  b b',
      ]);
      print(templateAreas.entries.join('\n'));
    });
  });
}
