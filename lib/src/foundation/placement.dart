import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

/// Represents a rectangular region on the grid.
@immutable
class GridArea {
  GridArea({
    this.name,
    this.columnStart,
    this.columnEnd,
    this.rowStart,
    this.rowEnd,
  });

  GridArea.withSpans({
    this.name,
    this.columnStart,
    int columnSpan,
    this.rowStart,
    int rowSpan,
  })  : this.columnEnd = columnStart + columnSpan,
        this.rowEnd = rowStart + rowSpan;

  final String name;
  final int columnStart;
  final int rowStart;

  /// The end column, exclusive
  final int columnEnd;
  int get columnSpan => columnEnd - columnStart;

  /// The end row, exclusive
  final int rowEnd;
  int get rowSpan => rowEnd - rowStart;

  int startForAxis(Axis axis) =>
      axis == Axis.horizontal ? columnStart : rowStart;
  int endForAxis(Axis axis) => axis == Axis.horizontal ? columnEnd : rowEnd;
  int spanForAxis(Axis axis) => endForAxis(axis) - startForAxis(axis);

  @override
  int get hashCode =>
      hashObjects(<dynamic>[name, columnStart, columnEnd, rowStart, rowEnd]);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    if (identical(other, this)) return true;
    return other is GridArea &&
        other.name == name &&
        other.columnStart == columnStart &&
        other.columnEnd == columnEnd &&
        other.rowStart == rowStart &&
        other.rowEnd == rowEnd;
  }

  @override
  String toString() {
    return 'GridArea(' +
        (name != null ? 'name=$name, ' : '') +
        'columnSpan=[$columnStart–$columnEnd], rowSpan=[$rowStart–$rowEnd])';
  }
}

/// Describes the named areas of a grid for [LayoutGrid.areas].
///
/// Named areas can be used for the placement of grid items, via
/// [NamedAreaGridPlacement].
///
/// Use [gridAreas] to produce one of these objects based on a string
/// formatted similarly to CSS's `grid-template-areas`.
/// ``
class NamedGridAreas {
  NamedGridAreas({
    @required this.columnCount,
    @required this.rowCount,
    @required Map<String, GridArea> namedAreas,
  }) : _namedAreas = namedAreas;

  final int columnCount;
  final int rowCount;
  final Map<String, GridArea> _namedAreas;

  /// The number of named areas
  int get length => _namedAreas.length;

  /// The [GridArea] named [areaName], or `null` if it does not exist
  GridArea operator [](String areaName) => _namedAreas[areaName];
}

/// Parses a set of strings into a description of the grid's named areas.
///
/// The format of [specRows] is identical to the format supplied to CSS Grid
/// Layout's `grid-template-areas` property:
/// https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-areas
///
/// Example input:
///
///     [
///       "head head",
///       "nav  main",
///       "nav  foot",
///     ];
///
NamedGridAreas gridAreas(List<String> specRows) {
  final gridAreaBuilders = <String, _GridAreaBuilder>{};
  int columnCount;

  for (int currentRow = 0; currentRow < specRows.length; currentRow++) {
    final tokens = specRows[currentRow].trim().split(_tokenSeparatorPattern);

    if (columnCount == null) {
      columnCount = tokens.length;
    } else if (columnCount != tokens.length) {
      throw ArgumentError(
          'Row ($currentRow) has the wrong number of area names, '
          'expected=$columnCount found=${tokens.length}');
    }

    for (int currentColumn = 0;
        currentColumn < tokens.length;
        currentColumn++) {
      final token = tokens[currentColumn];
      if (_isNamedCellToken(token)) {
        final builder =
            gridAreaBuilders.putIfAbsent(token, () => _GridAreaBuilder(token));
        builder.addCell(currentColumn, currentRow);
      } else if (!_isNullCellToken(token)) {
        throw ArgumentError('Invalid area name, name=$token\n'
            r'Must be in /^[a-zA-Z][\w\d-_]*$/');
      }
    }
  }

  return NamedGridAreas(
    columnCount: columnCount,
    rowCount: specRows.length,
    namedAreas: gridAreaBuilders.map(
      (name, builder) => MapEntry(name, builder.build()),
    ),
  );
}

final _tokenSeparatorPattern = RegExp(r'\s+');

final _nullCellPattern = RegExp(r'^\.+$');
bool _isNullCellToken(String token) => _nullCellPattern.hasMatch(token);

final _namedCellPattern = RegExp(r'^[a-zA-Z][\w\d-_]*$');
bool _isNamedCellToken(String token) => _namedCellPattern.hasMatch(token);

/// Determines the region of a [GridArea] by adding individual (column, row)
/// pairs.
class _GridAreaBuilder {
  _GridAreaBuilder(this.areaName);
  final String areaName;

  int _minColumn;
  int _maxColumn;
  int _minRow;
  int _maxRow;

  /// When a new column or row is introduced to the area when adding a cell,
  /// there will be a number of cells that require filling in order for the area
  /// to become a complete rectangle. This keeps track of that count. If
  /// non-zero, the [build] method will throw.
  int _missingCells = 0;

  void addCell(int column, int row) {
    if (_minColumn == null) {
      _minColumn = _maxColumn = column;
      _missingCells++;
    } else if (_ensureColumnInRange(column)) {
      _missingCells += _addedColumnCount(column) * (_maxRow - _minRow + 1);
      _minColumn = min(_minColumn, column);
      _maxColumn = max(_maxColumn, column);
    } else {
      throw ArgumentError(
          'Area disjoint, column=$column row=$row name=$areaName');
    }

    if (_minRow == null) {
      _minRow = _maxRow = row;
    } else if (_ensureRowInRange(row)) {
      _missingCells += _addedRowCount(row) * (_maxColumn - _minColumn + 1);
      _minRow = min(_minRow, row);
      _maxRow = max(_maxRow, row);
    } else {
      throw ArgumentError(
          'Area disjoint, column=$column row=$row name=$areaName');
    }

    _missingCells--;
  }

  bool _ensureColumnInRange(int column) => _addedColumnCount(column) <= 1;
  int _addedColumnCount(int column) {
    return column <= _minColumn
        ? _minColumn - column
        : column >= _maxColumn
            ? column - _maxColumn
            : 0;
  }

  bool _ensureRowInRange(int row) => _addedRowCount(row) <= 1;
  int _addedRowCount(int row) {
    return row <= _minRow
        ? _minRow - row
        : row >= _maxRow
            ? row - _maxRow
            : 0;
  }

  GridArea build() {
    if (_missingCells != 0) {
      throw ArgumentError('Missing cells from grid area template. '
          'Areas must be rectangular. name=$areaName');
    }

    return GridArea(
      name: areaName,
      columnStart: _minColumn,
      columnEnd: _maxColumn + 1,
      rowStart: _minRow,
      rowEnd: _maxRow + 1,
    );
  }
}
