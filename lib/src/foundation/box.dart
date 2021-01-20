import 'package:flutter/rendering.dart';
import 'package:flutter_layout_grid/src/widgets/layout_grid.dart';

extension LayoutGridExtensionsForBoxConstraints on BoxConstraints {
  /// Returns a new [BoxConstraints] tightening or loosening the receiver as
  /// specified by [gridFit].
  BoxConstraints constraintsForGridFit(GridFit gridFit) {
    switch (gridFit) {
      case GridFit.expand:
        return BoxConstraints.tight(biggest);

      case GridFit.loose:
        return loosen();

      case GridFit.passthrough:
        return this;
    }

    throw StateError('$gridFit is not a valid gridFit');
  }
}
