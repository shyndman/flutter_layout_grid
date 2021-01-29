# Flutter Layout Grid

[![Pub](https://img.shields.io/pub/v/flutter_layout_grid)](https://pub.dev/packages/flutter_layout_grid)
[![Github test](https://github.com/madewithfelt/flutter_layout_grid/workflows/test/badge.svg)](https://github.com/madewithfelt/flutter_layout_grid/actions?query=workflow%3Atest)

<a href="https://github.com/madewithfelt/flutter_layout_grid/blob/master/example/piet_painting_named_areas.dart">
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

_Click images to see their code_

---

A grid layout system for Flutter, optimized for user interface design, inspired by [CSS Grid
Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout).

✨Featuring:✨

- Fixed, flexible, and content-based row and column sizing
- Precise control over placement of items if desired, including the ability to span rows, columns,
  and overlap items
- Named areas 🆕
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

This is how you would specify an application layout using `LayoutGrid`:

```dart
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        namedAreas: gridAreas([
          'header header  header ',
          'nav    content aside  ',
          'nav    content .      ',
          'footer footer  footer ',
        ]),
        // A number of extension methods are provided for concise track sizing
        columnSizes: [240.px, 1.fr, auto],
        rowSizes: [
          144.px,
          auto,
          1.fr,
          240.px,
        ],
        children: [
          Header().inGridArea('header'),
          Navigation().inGridArea('nav'),
          Content().inGridArea('content'),
          Aside().inGridArea('aside'),
          Footer().inGridArea('footer'),
        ],
      ),
    );
  }
}
```

This example is available at
[`example/app_layout.dart`](/example/app_layout.dart).

For a similar example that includes responsive behavior, check out
[`example/responsive_app_layout.dart`](/example/responsive_app_layout.dart).

## Usage

### Sizing of Columns and Rows

There are currently three way to size tracks (rows or columns):

| Class Name                  | Description                                                                                                                                       | Usage                                                  |
|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| `FixedTrackSize`            | Occupies a specific number of pixels on an axis                                                                                                   | `FixedTrackSize(64)`, `fixed(64)`, or `64.px`          |
| `FlexibleSizeTrack`         | Fills remaining space after the initial layout has completed                                                                                      | `FlexibleTrackSize(1)`, `flexible(1)`, or `1.fr`       |
| `IntrinsicContentTrackSize` | Sized to contain its items' contents. Will also expand to fill available space,  once `FlexibleTrackSize` tracks have been given the opportunity. | `IntrinsicContentTrackSize()`, `intrisic()`, or `auto` |

Technically, you could define your own, but I wouldn't because the API will be
evolving.

### Placing widgets in the `LayoutGrid`

When a widget is provided to `LayoutGrid.children`, it will be allotted a
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
areas of a grid can be named via `LayoutGrid.areas` and
the `NamedAreaGridPlacement` widget. For example:

```dart
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

LayoutGrid(
  areas: gridAreas([
    'a a .',
    'a a b',
    '. . b',
  ]),
  // Note that the number of columns and rows matches the grid above (3x3)
  columnSizes: [fixed(100), fixed(100), fixed(100)],
  rowSizes: [fixed(100), fixed(100), fixed(100)],
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
  columnSizes: [/*...*/],
  rowSizes: [/*...*/],
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
