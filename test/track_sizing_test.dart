import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_layout_grid/src/rendering/layout_grid.dart';

void main() {
  group('track sizing', () {
    test('not sure yet', () {
      final renderGrid = RenderLayoutGrid(textDirection: TextDirection.ltr);
      renderGrid.performTrackSizing(
        TrackType.column,
        GridSizing.fromTrackSizeFunctions(
          columnSizeFunctions: [
            FixedTrackSize(40),
            IntrinsicContentTrackSize(),
          ],
          rowSizeFunctions: [
            FixedTrackSize(40),
            IntrinsicContentTrackSize(),
          ],
        ),
        constraints: BoxConstraints.tight(Size(400, 300)),
      );
    });
  });
}
