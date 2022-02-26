extension IterableExt<E> on Iterable<E> {
  /// Returns a new iterable based on this one with all duplicates removed. The
  /// first occurrence of each element with a duplicate will be retained.
  Iterable<E> removeDuplicates() =>
      _WhereBuilderIterable(this, _removeDuplicatesPredicate);
}

/// Removes duplicate elements from a collection. The type `T` should implement
/// [Object.hashCode] and [Object.==], if value-based comparison is desired.
///
/// Can be provided as a predicate to [List.removeWhere], [Set.removeWhere],
/// and others.
bool Function(T) _removeDuplicatesPredicate<T>() {
  final seen = <T>{};
  return seen.add;
}

/// Sums the elements of [numbers], and returns the result.
T sum<T extends num>(Iterable<T> numbers) {
  return numbers.fold(zeroForType<T>(), (acc, number) => (acc + number) as T);
}

/// Returns an iterable of [number]'s cumulative sums.
///
/// ```
/// cumulativeSum([1, 2, 3]) // 0, 1, 3, 6
/// cumulativeSum([2.0, 4.0, 6.0]) // 0.0, 2.0, 6.0, 12.0
/// ```
Iterable<T> cumulativeSum<T extends num>(
  Iterable<T> numbers, {
  bool includeLast = true,
}) sync* {
  T current = zeroForType<T>();
  for (final i in numbers) {
    yield current;
    current = (current + i) as T;
  }
  if (includeLast) yield current;
}

/// Returns the representation of `0` for a [num] type `T`.
T zeroForType<T extends num>() => (T == int ? 0 : 0.0) as T;

/// A filtering iterable, that invokes the provided predicate builder every time
/// an iterator is requested. This allows predicates to hold state.
class _WhereBuilderIterable<E> extends Iterable<E> {
  final Iterable<E> _iterable;
  final _ElementPredicate<E> Function() _predicateBuilder;

  _WhereBuilderIterable(this._iterable, this._predicateBuilder);

  @override
  Iterator<E> get iterator =>
      _WhereIterator(_iterable.iterator, _predicateBuilder());
}

class _WhereIterator<E> extends Iterator<E> {
  final Iterator<E> _iterator;
  final _ElementPredicate<E> _f;

  _WhereIterator(this._iterator, this._f);

  @override
  bool moveNext() {
    while (_iterator.moveNext()) {
      if (_f(_iterator.current)) {
        return true;
      }
    }
    return false;
  }

  @override
  E get current => _iterator.current;
}

typedef _ElementPredicate<E> = bool Function(E element);
