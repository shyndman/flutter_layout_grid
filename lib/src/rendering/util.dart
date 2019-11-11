import 'package:flutter/rendering.dart';
import 'track_size.dart';
import 'layout_grid.dart';

int sortByGrowthPotential(GridTrack a, GridTrack b) {
  if (a.isInfinite != b.isInfinite) return a.isInfinite ? -1 : 1;
  return (a.growthLimit - a.baseSize).compareTo(b.growthLimit - b.baseSize);
}

bool Function(RenderBox) startsInTrack(Axis axis, int index) {
  return _map((parentData) {
    return parentData.startForAxis(axis) == index;
  });
}

bool Function(RenderBox) hasSpan(Axis axis, int span) {
  return _map((parentData) {
    return parentData.spanForAxis(axis) == span;
  });
}

int Function(RenderBox) getSpan(Axis axis) {
  return _map((parentData) => parentData.spanForAxis(axis));
}

bool Function(GridTrack) isIntrinsic(
    TrackType type, BoxConstraints gridConstraints) {
  return (track) =>
      track.sizeFunction.isIntrinsicForConstraints(type, gridConstraints);
}

bool Function(GridTrack) isFlexible(
    TrackType type, BoxConstraints gridConstraints) {
  return (track) => track.sizeFunction.isFlexible;
}

T Function(RenderBox) _map<T>(T Function(GridParentData) predicate) {
  return (RenderBox item) => predicate(item.parentData as GridParentData);
}

bool Function(T) removeDuplicates<T>() {
  final seen = <T>{};
  return seen.add;
}

T sum<T extends num>(Iterable<T> numbers) {
  return numbers.fold(zeroForType<T>(), (acc, number) => acc + number);
}

Iterable<T> cumulativeSum<T extends num>(
  Iterable<T> numbers, {
  bool includeLast,
}) sync* {
  includeLast ??= true;
  T current = zeroForType<T>();
  for (final i in numbers) {
    yield current;
    current += i;
  }
  if (includeLast) yield current;
}

T zeroForType<T extends num>() {
  return (T == int ? 0 : 0.0) as T;
}
