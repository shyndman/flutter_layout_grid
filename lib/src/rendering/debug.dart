import 'package:flutter/widgets.dart';

import 'layout_grid.dart';

/// If `true`, track sizing will be logged to the console via Flutter's
/// [debugPrint] function.
bool debugPrintGridLayout = false;

/// If `true`, unplaced children will be logged to the console via Flutter's
/// [debugPrint] function.
bool debugPrintUnplacedChildren = false;

String debugTrackIndicesString(Iterable<GridTrack> tracks,
    {bool trackPrefix = false}) {
  final trackIndices = debugPrettyIndices(tracks.map((t) => t.index));

  return tracks.isEmpty
      ? trackIndices
      : tracks.length == 1
          ? 'track $trackIndices'
          : 'tracks $trackIndices';
}

String debugPrettyIndices(Iterable<int> indices) {
  return indices.isEmpty
      ? '(none)'
      : indices.length > 1
          ? '[${indices.join(',')}]'
          : '${indices.first}';
}
