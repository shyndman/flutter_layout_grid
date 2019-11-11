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
