import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import './piet_painting.dart';

void main() {
  runApp(PietNamedAreasApp());
}

class PietNamedAreasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Layout Grid Desktop Example',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      builder: (context, child) => PietPainting(),
    );
  }
}

class PietPainting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: LayoutGrid(
        columnGap: 12,
        rowGap: 12,
        templateAreas: gridTemplateAreas([
          'r R B B  B',
          'r R Y Y  Y',
          'y R Y Y  Y',
          'y R g b yy',
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
          gridArea('r').containing(Container(color: cellRed)),
          gridArea('y').containing(Container(color: cellMustard)),
          // Column 2
          gridArea('R').containing(Container(color: cellRed)),
          // Column 3
          gridArea('B').containing(Container(color: cellBlue)),
          gridArea('Y').containing(Container(color: cellMustard)),
          gridArea('g').containing(Container(color: cellGrey)),
          // Column 4
          gridArea('b').containing(Container(color: cellBlue)),
          // Column 5
          gridArea('yy').containing(Container(color: cellMustard)),
        ],
      ),
    );
  }
}
