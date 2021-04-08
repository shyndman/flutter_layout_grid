import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(DragAndDropApp());
}

const cellSize = 32.0;
const columnCount = 16;
const rowCount = 16;

class DragAndDropExample extends StatefulWidget {
  @override
  _DragAndDropExampleState createState() => _DragAndDropExampleState();
}

class _DragAndDropExampleState extends State<DragAndDropExample> {
  /// The [Draggable] and [DragTarget] widgets need to be associated with some
  /// type of data through their type argument. `void` is not a valid option
  /// unfortunately, and will cause exceptions in the drag system.
  ///
  /// We keep it simple and use a key, since we don't actually need to
  /// communicate anything about the dragged data.
  Key draggableKey = UniqueKey();

  /// Current position of the [DraggableGridItem].
  GridPosition draggablePosition = GridPosition(0, 0);

  void gridItemMoved(GridPosition position) {
    setState(() {
      this.draggablePosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnGap: 0,
      rowGap: 0,
      columnSizes: repeat(columnCount, [cellSize.px]),
      rowSizes: repeat(rowCount, [cellSize.px]),
      children: [
        // Fill the grid with a `Cell` widget per cell (basically a
        // `DragTarget`)
        for (int i = 0; i < columnCount; i++)
          for (int j = 0; j < rowCount; j++)
            Cell(
              column: i,
              row: j,
              // Invoked when the user drops a DraggableGridItem on the cell
              cellBecameOccupied: gridItemMoved,
            ).withGridPlacement(columnStart: i, rowStart: j),
        // And a single draggable grid item (basically a styled `Draggable`),
        // positioned according to the `draggablePosition` field.
        DraggableGridItem(
          key: draggableKey,
        ).withGridPlacement(
          columnStart: draggablePosition.x,
          rowStart: draggablePosition.y,
        )
      ],
    );
  }
}

/// A square that can be dragged between grid cells.
class DraggableGridItem extends StatelessWidget {
  DraggableGridItem({
    @required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final square = Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[300], Colors.blue[700]],
        ),
      ),
    );

    return Draggable<Key>(
      data: key,
      // The widget displayed under the mouse during a drag. We scale it up
      // and make it transparent to add a bit of emphasis.
      feedback: Opacity(
        opacity: 0.6,
        child: Transform.scale(
          scale: 1.2,
          // SizedBox is required here, because the feedback widget isn't bound
          // by a cell and wants to be zero-sized.
          child: SizedBox(
            width: cellSize,
            height: cellSize,
            child: square,
          ),
        ),
      ),
      // The child that remains in the grid during a drag. We fade a bit for
      // style.
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: square,
      ),
      child: square,
    );
  }
}

/// Acts as a position that can be occupied by the [DraggableGridItem] widget.
///
/// While a drag is active, instances of this widget will display an emphasized
/// border when the user's pointer is over it, indicating that it will be the
/// recipient of the drop upon release.
class Cell extends StatefulWidget {
  const Cell({
    Key key,
    this.column,
    this.row,
    this.cellBecameOccupied,
  }) : super(key: key);

  /// The column this cell occupies
  final int column;

  /// The row this cell occupies
  final int row;

  /// Invoked when the user drops a [DraggableGridItem] on this cell.
  final DragTargetAccept<GridPosition> cellBecameOccupied;

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  /// `true` if a drag is active, and the user's pointer is over this cell
  bool isDragHovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Key>(
      onAccept: (_) {
        setState(() => isDragHovering = false);
        widget.cellBecameOccupied(GridPosition(widget.column, widget.row));
      },
      onMove: (details) => setState(() => isDragHovering = true),
      onLeave: (details) => setState(() => isDragHovering = false),
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            // Big obvious purple border to indicate it will receive the drop
            border: isDragHovering
                ? Border.all(
                    color: Colors.purple[400],
                    width: 2,
                  )
                : Border.all(
                    color: Colors.grey[400],
                  ),
          ),
        );
      },
    );
  }
}

class GridPosition {
  GridPosition(this.x, this.y);
  final int x;
  final int y;
}

class DragAndDropApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: DragAndDropExample(),
          ),
        ),
      ),
    );
  }
}
