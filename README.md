# Flutter Layout Grid

[![Pub](https://img.shields.io/pub/v/flutter_layout_grid)](https://pub.dev/packages/flutter_layout_grid)
[![Github test](https://github.com/madewithfelt/flutter_layout_grid/workflows/test/badge.svg)](https://github.com/madewithfelt/flutter_layout_grid/actions?query=workflow%3Atest)

<a href="https://github.com/madewithfelt/flutter_layout_grid/blob/master/example/flutter_layout_grid.dart">
  <img
    src="https://raw.githubusercontent.com/shyndman/flutter_layout_grid/master/doc/images/piet_trimmed.png"
    alt="Piet painting recreated using Flutter Layout Grid" height="220">
</a>
&nbsp;
&nbsp;
<a href="https://github.com/madewithfelt/flutter_layout_grid/blob/master/example/periodic_table.dart">
  <img
    src="https://raw.githubusercontent.com/shyndman/flutter_layout_grid/master/doc/images/periodic_table.png"
    alt="Periodic table rendered using Flutter Layout Grid" height="220">
</a>

---

A grid layout system for Flutter, optimized for user interface design, inspired by [CSS Grid
Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout).

✨Featuring:✨

- Fixed, flexible, and content-based row and column sizing
- Precise control over placement of items if desired, including the ability to span rows, columns,
  and overlap items
- A configurable automatic grid item placement algorithm, capable of sparse and dense packing across
  rows and columns
- Right-to-left support, driven by ambient `Directionality` or configuation
- Gutters!

## Getting Started

All the terminology used in this library is shared with the CSS Grid Layout spec. If you're
unfamiliar, I recommend taking a look at [MDN's glossary of grid
terms](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout#Glossary_entries).

For inclusion in your pubspec, see
[pub.dev](https://pub.dev/packages/flutter_layout_grid#-installing-tab-).

### Null-safe support

For a null-safe version of the library, use `flutter_layout_grid: ^0.11.0-nullsafety.1`

### Flutter pre-v1.14.0 support

For Flutter versions before v1.14.0, use `flutter_layout_grid: ^0.9.0`

## Example

This is the source for the sample you can see above.

```dart
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

const cellRed = Color(0xffc73232);
const cellMustard = Color(0xffd7aa22);
const cellGrey = Color(0xffcfd4e0);
const cellBlue = Color(0xff1553be);
const background = Color(0xff242830);

class PietPainting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        templateAreas: gridTemplateAreas([
          'r R  b  b  b',
          'r R  Y  Y  Y',
          'y R  Y  Y  Y',
          'y R sg sb sy',
        ]),
        // A number of extension methods are provided for concise track sizing
        templateColumnSizes: [1.0.fr, 3.5.fr, 1.3.fr, 1.3.fr, 1.3.fr],
        templateRowSizes: [
          1.0.fr,
          0.3.fr,
          1.5.fr,
          1.2.fr,
        ],
        children: [
          // Column 1
          Container(color: cellRed).inGridArea('r'),
          Container(color: cellMustard).inGridArea('y'),
          // Column 2
          Container(color: cellRed).inGridArea('R'),
          // Column 3
          Container(color: cellBlue).inGridArea('b'),
          Container(color: cellMustard).inGridArea('Y'),
          Container(color: cellGrey).inGridArea('sg'),
          // Column 4
          Container(color: cellBlue).inGridArea('sb'),
          // Column 5
          Container(color: cellMustard).inGridArea('sy'),
        ],
      ),
    );
  }
}
```

## Usage

### Sizing of Columns and Rows

There are currently three way to size tracks (rows or columns):

- `FixedSizeTrack` — occupies a specific number of pixels on an axis
- `FlexibleSizeTrack` — consumes remaining space after the initial layout has
  completed.
- `IntrinsicContentTrackSize` — sized to contain its items' contents. Will also
  expand to fill available space, once `FlexibleTrackSize` tracks have been
  given the opportunity.

Technically, you could define your own, but I wouldn't because the API will be
evolving.

### Placing widgets in the `LayoutGrid`

When a widget is provided via `LayoutGrid.children`, it will be allotted a
single cell and placed automatically according to the `LayoutGrid.autoPlacement`
algorithm ([described
here](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/Auto-placement_in_CSS_Grid_Layout)).

```dart
LayoutGrid(
  templateColumnSizes = [/*...*/];
  templateRowSizes = [/*...*/];
  children: [
    MyWidget(), // Will occupy a 1x1 in the first vacant cell
  ],
)
```

Precise control over placement of an item is provided via the
`NamedAreaGridPlacement` and `GridPlacement` widgets.

#### Placement in Named Areas

Similarly to CSS's
[`grid-template-areas`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-areas),
areas of a grid can be named via `LayoutGrid.templateAreas` and
the `NamedAreaGridPlacement` widget. For example:

```dart
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

LayoutGrid(
  templateAreas: gridTemplateAreas([
    'a a .',
    'a a b',
    '. . b',
  ]),
  // Note that the number of columns and rows matches the grid above (3x3)
  templateColumnSizes: [FixedTrackSize(100), FixedTrackSize(100), FixedTrackSize(100)],
  templateRowSizes: [FixedTrackSize(100), FixedTrackSize(100), FixedTrackSize(100)],
  children: [
    // Using NamedAreaGridPlacement constructor
    NamedAreaGridPlacement(
      areaName: 'a',
      child: Container(color: Colors.blue),
    ),Î
    // Same effect as above, but using an extension method
    Container(color: Colors.red).inGridArea('b'),
  ],
)
```

#### Explicit placement via row/column indices

You can think of `GridPlacement` as the
[`Positioned`](https://api.flutter.dev/flutter/widgets/Positioned-class.html)
equivalent for `LayoutGrid` — it controls the where a widget is placed, and the
cells it occupies.

```dart
LayoutGrid(
  templateColumnSizes: [/*...*/],
  templateRowSizes: [/*...*/],
  children: [
    GridPlacement(
      // All parameters optional
      columnStart: 1,
      columnSpan: 3,
      rowStart: 5,
      rowSpan: 2,
      child: MyWidget(),
    ),
  ],
)
```

Alternatively, `GridPlacement`s can be created using the `withGridPlacement`
extension method on `Widget`. Using this method, the example above becomes:

```dart
LayoutGrid(
  templateColumnSizes = [/*...*/];
  templateRowSizes = [/*...*/];
  children: [
    MyWidget().withGridPlacement(
      // All parameters optional
      columnStart: 1,
      columnSpan: 3,
      rowStart: 5,
      rowSpan: 2,
    ),
  ],
)
```

All of the `GridPlacement`'s constructor parameters are optional. It defaults to
a 1x1 grid item that will be placed automatically by the grid. Specifying
positioning or spanning information (via
`columnStart`/`columnSpan`/`rowStart`/`rowSpan` parameters) will feed additional
constraints into its algorithm.

A definitely-placed item (meaning `columnStart` and `rowStart` have both been
provided), will always be placed precisely, even if it overlaps other
definitely-placed items. Automatically-placed items will flow around those that
have been placed definitely.

##### Named Areas

#### Accessibility and Placement

Take note that the meaning you convey visually through placement may not be clear when presented
by assitive technologies, as Flutter defaults to exposing information in source order.

In situations where your semantic (visual) ordering differs from ordering in the source, the
ordering can be configured via the `Semantics` widget's
[`sortKey`](https://api.flutter.dev/flutter/semantics/SemanticsSortKey-class.html) parameter.

## Differences from CSS Grid Layout

Things in CSS Grid Layout that are not supported:

- Negative row/column starts/ends. In CSS, these values refer to positions relative to the end of a
  grid's axis.
- Any cells outside of the explicit grid. If an item is placed outside of the area defined by your
  template rows/columns, we will throw an error. Support for automatic addition of rows and columns
  to accommodate out of bound items is being considered.
- minmax(), percentages, aspect ratios track sizing
- Named template areas, although they're coming

Differences:

- In `flutter_layout_grid`, flexible tracks do not account for their content's base sizes as they do
  in CSS. It's expensive to measure, and I opted for speed.
- Flexible tracks whose flex factors sum to < 1

## Why not Slivers?

This library is not [Sliver](https://medium.com/flutter/slivers-demystified-6ff68ab0296f)-based. I'd
considered it, but my use cases required the content-based sizing of rows and columns, and I didn't
want to figure out the UI challenges associated with resizing tracks during scroll. I might be
interested in taking those on at some point.

## Roadmap

- [x] Tests! (we now have a decent suite going)
- [x] Named template areas, for friendlier item placement
- [ ] Improved track sizing, including minimum/maximums and aspect ratios
- [ ] The ability to specify row and column gaps at specific line locations via a delegate
- [ ] Implicit grid support (automatic growth along an axis as children are added)
- [x] Performance improvements, as soon as I can get this profiler running(!!!)
