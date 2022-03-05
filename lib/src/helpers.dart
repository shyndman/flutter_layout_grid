import 'package:flutter/widgets.dart';

import 'rendering/track_size.dart';
import 'widgets/placement.dart';

/// An [IntrinsicContentTrackSize], mirroring CSS's name for the track sizing
/// function.
const auto = IntrinsicContentTrackSize();

/// Returns a track size that is sized based on its contents.
IntrinsicContentTrackSize intrinsic({String? debugLabel}) =>
    IntrinsicContentTrackSize(debugLabel: debugLabel);

/// Returns a new track size that is exactly [sizeInPx] wide.
FixedTrackSize fixed(double sizeInPx, {String? debugLabel}) =>
    FixedTrackSize(sizeInPx, debugLabel: debugLabel);

/// Returns a new track size that expands to fill available space.
FlexibleTrackSize flex(double flexFactor, {String? debugLabel}) =>
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

/// Convenience function for pretty grid definitions, ala:
///
///     LayoutGrid(
///       areas: '''
///         pink   pink   .
///         pink   pink   red
///         orange yellow red
///       ''',
///       columnSizes: [fixed(100), fixed(100), fixed(100)],
///       rowSizes: [
///         fixed(100),
///         fixed(100),
///         fixed(100),
///        ],
///       children: [
///         //!!!
///         gridArea('pink').containing(Container(color: Colors.pink)),
///         gridArea('red').containing(Container(color: Colors.red)),
///         gridArea('orange').containing(Container(color: Colors.orange)),
///         gridArea('yellow').containing(Container(color: Colors.yellow)),
///       ],
///     )
///
NamedAreaGridPlacementBuilder gridArea(String name) {
  return NamedAreaGridPlacementBuilder._(name);
}

/// Dumb little helper class for slightly cleaner grid child placement
@immutable
class NamedAreaGridPlacementBuilder {
  const NamedAreaGridPlacementBuilder._(this.name);

  final String name;

  NamedAreaGridPlacement containing(Widget child) {
    return NamedAreaGridPlacement(
      areaName: name,
      child: child,
    );
  }
}
