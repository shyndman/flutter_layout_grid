import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(const SemanticOrderingApp());
}

class SemanticOrderingApp extends StatelessWidget {
  const SemanticOrderingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: Colors.white,
      builder: (_, __) => const SemanticOrdering(),
    );
  }
}

class SemanticOrdering extends StatelessWidget {
  const SemanticOrdering({Key? key}) : super(key: key);

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
        columnSizes: const [auto],
        rowSizes: const [
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
          Semantics(sortKey: const OrdinalSortKey(3), child: const Footer())
              .inGridArea('footer'),
          Semantics(sortKey: const OrdinalSortKey(1), child: const Header())
              .inGridArea('header'),
          Semantics(sortKey: const OrdinalSortKey(2), child: const Content())
              .inGridArea('content'),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.red,
        child: const Text('Header'),
      );
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey[300],
        child: const Text('Content'),
      );
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.deepPurple,
        child: const Text('Footer'),
      );
}
