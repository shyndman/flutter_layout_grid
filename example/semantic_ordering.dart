import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(SemanticOrderingApp());
}

class SemanticOrderingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: Colors.white,
      builder: (_, __) => SemanticOrdering(),
    );
  }
}

class SemanticOrdering extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      // We need to wrap the entire grid in a Semantics widget, with
      // `explicitChildNodes: true`, in order for sorting to work properly.
      explicitChildNodes: true,
      child: LayoutGrid(
        areas: '''
          header
          content
          footer
        ''',
        columnSizes: [auto],
        rowSizes: [
          auto,
          auto,
          auto,
        ],
        children: [
          // Using the Semantics widget and its sortKey tells screenreaders to
          // announce the children in the order you specify, regardless of their
          // ordering in source code (which is the default).
          //
          // In this example, you wouldn't want Footer() to be announced by the
          // screenreader first, would you? sortKey fixes that.
          Semantics(sortKey: OrdinalSortKey(3), child: Footer())
              .inGridArea('footer'),
          Semantics(sortKey: OrdinalSortKey(1), child: Header())
              .inGridArea('header'),
          Semantics(sortKey: OrdinalSortKey(2), child: Content())
              .inGridArea('content'),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.red,
        child: Text('Header'),
      );
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey[300],
        child: Text('Content'),
      );
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.deepPurple,
        child: Text('Footer'),
      );
}
