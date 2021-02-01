import 'dart:ui';

// Responsiveness

Size viewportSize = Size.zero;

extension ViewportUnits on num {
  double get vw => viewportSize.width * (this / 100.0);
}

// Formatting

extension DoubleFormatting on double {
  /// Formats a double with a maximum precision of [maxFractionDigits]. Any
  /// trailing zeroes will be trimmed from the returned string.
  String toStringAsMaxFixed([int maxFractionDigits = 2]) {
    return this
        .toStringAsFixed(maxFractionDigits)
        .replaceAll(RegExp(r'\.?0+$'), '');
  }
}

// Iterables

extension ListExt<T> on List<T> {
  List<T> operator *(int times) => generate(times).expand((e) => this).toList();
}

Iterable<void> generate(int times) sync* {
  for (int i = 0; i < times; i++) {
    yield 0;
  }
}
