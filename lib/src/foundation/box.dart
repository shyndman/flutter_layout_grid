import 'package:flutter/rendering.dart';
import 'package:flutter_layout_grid/src/widgets/layout_grid.dart';

extension LayoutGridExtensionsForBoxConstraints on BoxConstraints {
  /// Returns a new [BoxConstraints] with unbounded (infinite) maximums.
  BoxConstraints get unbound =>
      copyWith(maxWidth: double.infinity, maxHeight: double.infinity);

  /// Returns a new [BoxConstraints] tightening or loosening the receiver as
  /// specified by [gridFit].
  BoxConstraints constraintsForGridFit(GridFit gridFit) {
    switch (gridFit) {
      case GridFit.expand:
        final upperBound = biggest;
        return BoxConstraints.tightForFinite(
          width: upperBound.width,
          height: upperBound.height,
        );

      case GridFit.loose:
        return loosen();

      case GridFit.passthrough:
        return this;
    }
  }
}
