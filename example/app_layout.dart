import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

void main() {
  runApp(DesktopLayoutApp());
}

class DesktopLayoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
        color: Colors.white,
        builder: (context, child) {
          return DesktopLayout();
        });
  }
}

class DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      child: LayoutGrid(
        areas: gridAreas([
          'header header  header',
          'nav    content aside ',
          'nav    content .     ',
          'footer footer  footer',
        ]),
        // A number of extension methods are provided for concise track sizing
        columnSizes: [224.px, 1.fr, auto],
        rowSizes: [
          144.px,
          auto,
          1.fr,
          112.px,
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

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(color: Colors.red);
}

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(color: Colors.purple);
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(color: Colors.grey[300]);
}

class Aside extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.grey[600], width: 184);
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(color: Colors.deepPurple);
}
