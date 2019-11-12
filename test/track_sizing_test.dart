import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';

void main() {
  group('track sizing', () {
    test('not sure yet', () {
      final renderGrid = RenderLayoutGrid(
        templateColumnSizes: null,
        templateRowSizes: null,
      );
      renderGrid.performTrackSizing(
        TrackType.column,
        GridSizingInfo.fromTrackSizeFunctions(
          columnSizeFunctions: [
            FixedTrackSize(40),
            FlexibleTrackSize(1),
          ],
          rowSizeFunctions: [
            FixedTrackSize(40),
            FlexibleTrackSize(1),
          ],
          textDirection: TextDirection.ltr,
        ),
        constraints: BoxConstraints.tight(Size(400, 300)),
      );
    });
  });
}
