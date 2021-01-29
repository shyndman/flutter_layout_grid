/// Defines a set of helpers functions for building track sizes.
///
/// This is in its own package to avoid conflicts.
library track_size_helpers;

import 'package:flutter_layout_grid/flutter_layout_grid.dart';

/// An [IntrinsicContentTrackSize], mirroring CSS's name for the track sizing
/// function.
const auto = IntrinsicContentTrackSize();

/// Returns a track size that is sized based on its contents.
IntrinsicContentTrackSize intrinsic({String debugLabel}) =>
    IntrinsicContentTrackSize(debugLabel: debugLabel);

/// Returns a new track size that is exactly [sizeInPx] wide.
FixedTrackSize fixed(double sizeInPx, {String debugLabel}) =>
    FixedTrackSize(sizeInPx, debugLabel: debugLabel);

/// Returns a new track size that expands to fill available space.
FlexibleTrackSize flex(double flexFactor, {String debugLabel}) =>
    FlexibleTrackSize(flexFactor, debugLabel: debugLabel);

/// Defines a set of extension methods on [num] for creating tracks
extension TrackUnitsNumExtension on num {
  FixedTrackSize get px => fixed(toDouble());
  FlexibleTrackSize get fr => flex(toDouble());
}

/// Returns this list repeated [times] times.
///
///     repeat(2, [fixed(100), fixed(200)])
///     // [fixed(100), fixed(200), fixed(100), fixed(200)]
///
List<TrackSize> repeat(int times, List<TrackSize> tracks) =>
    _repeat(times, tracks).toList();

Iterable<T> _repeat<T>(int times, Iterable<T> source) sync* {
  for (int i = 0; i < times; i++) {
    yield* source;
  }
}
