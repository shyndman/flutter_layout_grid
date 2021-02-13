// periodic_table_json.json courtesy of
// https://github.com/Bowserinator/Periodic-Table-JSON
//
// Based on the work by Mike Golus
// https://www.csscodelab.com/html-css-only-periodic-table-of-elements/

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'example_helpers.dart';

void main() {
  runApp(PeriodicTableApp());
}

class PeriodicTableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xff101318),
      ),
      child: WidgetsApp(
        title: 'Periodic Table',
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        builder: (_, __) {
          return LayoutBuilder(builder: (_, constraints) {
            viewportSize = constraints.biggest;
            return SingleChildScrollView(child: PeriodicTableWidget());
          });
        },
      ),
    );
  }
}

/// Renders a periodic table.
class PeriodicTableWidget extends StatefulWidget {
  @override
  _PeriodicTableWidgetState createState() => _PeriodicTableWidgetState();
}

class _PeriodicTableWidgetState extends State<PeriodicTableWidget> {
  Future<PeriodicTable> tableFuture;

  @override
  void initState() {
    super.initState();
    tableFuture = loadPeriodicTable();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.vw, vertical: 1.vw),
      child: FutureBuilder(
        future: tableFuture,
        builder: (_, AsyncSnapshot<PeriodicTable> snapshot) {
          return snapshot.hasData ? _buildGrid(snapshot.data) : SizedBox();
        },
      ),
    );
  }

  Widget _buildGrid(PeriodicTable table) {
    // !!! This is the grid behind the periodic table! !!!
    //
    // The rest of the code is just details (what goes where, how things should
    // look, etc).
    return LayoutGrid(
      gridFit: GridFit.loose,
      columnSizes: repeat(table.numColumns, [1.fr]),
      rowSizes: repeat(table.numRows, [auto]),
      columnGap: 0.4.vw,
      rowGap: 0.4.vw,
      children: [
        for (final e in table.elements)
          AspectRatio(
            aspectRatio: 40.1 / 42.4,
            child: AtomicElementWidget(
              key: ValueKey(e.symbol),
              element: e,
            ),
          ).withGridPlacement(columnStart: e.x, rowStart: e.y),
      ],
    );
  }
}

// Mappings between atomic categories and their associated colors.
const categoryColorMapping = {
  AtomicElementCategory.actinide: Color(0xffc686cc),
  AtomicElementCategory.alkaliMetal: Color(0xffecbe59),
  AtomicElementCategory.alkalineEarthMetal: Color(0xffdee955),
  AtomicElementCategory.lanthanide: Color(0xffec77a3),
  AtomicElementCategory.metalloid: Color(0xff3aefb6),
  AtomicElementCategory.nobleGas: Color(0xff759fff),
  AtomicElementCategory.otherNonmetal: Color(0xff52ee61),
  AtomicElementCategory.postTransitionMetal: Color(0xff4cddf3),
  AtomicElementCategory.transitionMetal: Color(0xfffd8572),
  AtomicElementCategory.unknown: Color(0xffcccccc),
};

/// A widget representing an element's square on the periodic table.
class AtomicElementWidget extends StatelessWidget {
  AtomicElementWidget({Key key, this.element}) : super(key: key);
  final AtomicElement element;

  @override
  Widget build(BuildContext context) {
    final elementColor = categoryColorMapping[element.category];
    final elementTextStyle = TextStyle(
      color: elementColor,
      shadows: [
        Shadow(color: elementColor, offset: Offset.zero, blurRadius: 0.3.vw),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.2.vw,
          color: elementColor,
        ),
      ),
      // Some viewport sizes give us slight overflows, which can be attributed
      // to rounding errors. So we use a stack and allow overflow on the bottom
      // edge.
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            bottom: null,
            child: _buildElementDetails(elementTextStyle),
          ),
        ],
      ),
    );
  }

  Column _buildElementDetails(TextStyle elementTextStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.3.vw, 0.15.vw, 0, 0),
          child: Text(
            element.number.toString(),
            style: elementTextStyle.copyWith(fontSize: 0.5.vw),
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          element.symbol,
          style: elementTextStyle.copyWith(fontSize: 1.9.vw),
          textAlign: TextAlign.center,
          softWrap: false,
        ),
        Text(
          element.name,
          style: elementTextStyle.copyWith(fontSize: 0.65.vw),
          textAlign: TextAlign.center,
          softWrap: false,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.2.vw, 0.0, 0.3.vw),
          child: Text(
            element.formattedMass,
            style: elementTextStyle.copyWith(fontSize: 0.5.vw),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

Future<PeriodicTable> loadPeriodicTable() async {
  final elementsJson = JsonCodec().decode(
          await rootBundle.loadString('periodic_table_data.json'))['elements']
      as List<dynamic>;

  return PeriodicTable(elementsJson
      .cast<Map<String, dynamic>>()
      .map(AtomicElement.fromJson)
      .toList());
}

/// The elements and structure of the periodic table.
class PeriodicTable {
  PeriodicTable(this.elements) {
    for (final e in elements) {
      numColumns = math.max(e.x + 1, numColumns);
      numRows = math.max(e.y + 1, numRows);
    }
  }

  final List<AtomicElement> elements;
  int numColumns = 0;
  int numRows = 0;
}

/// Describes an atomic element, with a few view helpers and deserialization
/// logic.
class AtomicElement {
  AtomicElement({
    @required this.name,
    @required this.symbol,
    @required this.number,
    @required this.category,
    @required this.atomicMass,
    @required this.stableIsotope,
    @required this.x,
    @required this.y,
  });

  final String name;
  final String symbol;
  final int number;
  final AtomicElementCategory category;
  final double atomicMass;
  final bool stableIsotope;
  final int x;
  final int y;

  String get formattedMass => stableIsotope
      ? atomicMass.toStringAsMaxFixed(3)
      : '(${atomicMass.toStringAsFixed(0)})';

  @override
  String toString() => name;

  static AtomicElement fromJson(Map<String, dynamic> elementJson) {
    final atomicMass = elementJson['atomic_mass'] as num;
    return AtomicElement(
      name: elementJson['name'] as String,
      symbol: elementJson['symbol'] as String,
      number: elementJson['number'] as int,
      category: _parseAtomicElementCategory(elementJson['category'] as String),
      atomicMass: atomicMass.toDouble(),
      stableIsotope: atomicMass is double,
      x: (elementJson['xpos'] as int) - 1, // File is 1-based
      y: (elementJson['ypos'] as int) - 1, // File is 1-based
    );
  }
}

/// Categories of atomic element, as dictacted by...physics!
enum AtomicElementCategory {
  actinide,
  alkaliMetal,
  alkalineEarthMetal,
  lanthanide,
  metalloid,
  nobleGas,
  otherNonmetal,
  postTransitionMetal,
  transitionMetal,
  unknown,
}

AtomicElementCategory _parseAtomicElementCategory(String category) {
  switch (category) {
    case 'actinide':
      return AtomicElementCategory.actinide;
    case 'alkali metal':
      return AtomicElementCategory.alkaliMetal;
    case 'alkaline earth metal':
      return AtomicElementCategory.alkalineEarthMetal;
    case 'diatomic nonmetal':
      return AtomicElementCategory.otherNonmetal;
    case 'lanthanide':
      return AtomicElementCategory.lanthanide;
    case 'metalloid':
      return AtomicElementCategory.metalloid;
    case 'noble gas':
      return AtomicElementCategory.nobleGas;
    case 'polyatomic nonmetal':
      return AtomicElementCategory.otherNonmetal;
    case 'post-transition metal':
      return AtomicElementCategory.postTransitionMetal;
    case 'transition metal':
      return AtomicElementCategory.transitionMetal;
  }

  assert(category.startsWith('unknown'));
  return AtomicElementCategory.unknown;
}
