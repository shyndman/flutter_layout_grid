import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  group('template area parsing', () {
    test('produces correctly named GridAreas', () {
      final templateAreas = gridTemplateAreas([
        'logo     nav      nav      nav',
        'bar      main     main     main',
        'bar      main     main     main',
        'bar      main     main     main',
        'footer   footer   footer   footer',
      ]);
      expect(templateAreas.length, 5);
      expect(
        templateAreas['logo'],
        GridArea(
          name: 'logo',
          columnStart: 0,
          columnEnd: 1,
          rowStart: 0,
          rowEnd: 1,
        ),
      );
      expect(
        templateAreas['nav'],
        GridArea(
          name: 'nav',
          columnStart: 1,
          columnEnd: 4,
          rowStart: 0,
          rowEnd: 1,
        ),
      );
      expect(
        templateAreas['bar'],
        GridArea(
          name: 'bar',
          columnStart: 0,
          columnEnd: 1,
          rowStart: 1,
          rowEnd: 4,
        ),
      );
      expect(
        templateAreas['main'],
        GridArea(
          name: 'main',
          columnStart: 1,
          columnEnd: 4,
          rowStart: 1,
          rowEnd: 4,
        ),
      );
      expect(
        templateAreas['footer'],
        GridArea(
          name: 'footer',
          columnStart: 0,
          columnEnd: 4,
          rowStart: 4,
          rowEnd: 5,
        ),
      );
    });

    test('throws with disjoint area', () {
      expect(
        () => gridTemplateAreas(['a . . a']),
        throwsA(isInstanceOf<ArgumentError>()),
      );
    });

    test('throws with invalid name', () {
      expect(
        () => gridTemplateAreas(['\$aaa . . .']),
        throwsArgumentError,
      );
    });

    test('throws with incomplete area rectangles', () {
      expect(
        () => gridTemplateAreas([
          'a . . .',
          'a a . .',
          'a a . .',
        ]),
        throwsArgumentError,
      );
    });

    test('throws with changing explicit grid columns', () {
      expect(
        () => gridTemplateAreas([
          'a . . .',
          'a . . . .',
          'a . . .',
        ]),
        throwsArgumentError,
      );
    });
  });
}
