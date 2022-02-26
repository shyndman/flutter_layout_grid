import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:google_fonts/google_fonts.dart';

import 'support/inner_shadow.dart';

void main() {
  runApp(const ScrabbleApp());
}

class ScrabbleApp extends StatelessWidget {
  const ScrabbleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Layout Grid Scrabble Example',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      builder: (context, child) => Container(
        color: const Color(0xfffefdff),
        child: Center(
          child: ScrabbleBoard(
            tiles: getTiles(),
          ),
        ),
      ),
    );
  }
}

List<TileInfo> getTiles() {
  const tileLayout = '''
    .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  G  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  R  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  E  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  A  .  .  G  .  .  .
    .  .  .  .  .  F  L  U  T  T  E  R  .  .  .
    .  .  .  W  .  .  A  H  .  .  .  I  S  .  .
    .  .  .  O  .  .  Y  .  .  .  .  D  .  .  .
    .  .  A  W  E  S  O  M  E  .  .  .  .  .  .
    .  .  U  .  .  .  U  .  .  .  .  .  .  .  .
    .  .  T  .  .  .  T  R  Y  .  .  .  .  .  .
    .  N  O  W  .  .  .  .  .  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
    .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
  ''';
  return parseTiles(tileLayout).toList();
}

const trackCount = 15;
const doubleLetterCount = 24;
const doubleWordCount = 16;
const tripleLetterCount = 12;
const tripleWordCount = 8;
const tileCount = trackCount * trackCount; // star

class ScrabbleBoard extends StatelessWidget {
  const ScrabbleBoard({
    Key? key,
    required this.tiles,
  }) : super(key: key);

  final List<TileInfo> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      areas: '''
        tw0 .  . dl0 .  .  . tw1 .  .  . dl1 .  . tw2
         . dw0 .  .  . tl0 .  .  . tl1 .  .  . dw1 .
         .  . dw2 .  .  . dl2 . dl3 .  .  . dw3 .  .
        dl4 .  . dw4 .  .  . dl5 .  .  . dw5 .  .  dl6
         .  .  .  . dw6 .  .  .  .  . dw7 .  .  .  .
         . tl2 .  .  . tl3 .  .  . tl4 .  .  . tl5 .
         .  . dl7 .  .  . dl8 . dl9 .  .  . dla .  .
        tw3 .  . dlb .  .  .  ★  .  .  . dlc .  .  tw4
         .  . dld .  .  . dle . dlf .  .  . dlg .  .
         . tl6 .  .  . tl7 .  .  . tl8 .  .  . tl9 .
         .  .  .  . dw8 .  .  .  .  . dw9 .  .  .  .
        dlh .  . dwa .  .  . dli .  .  . dwb .  .  dlj
         .  . dwc .  .  . dlk . dll .  .  . dwd .  .
         . dwe .  .  . tla .  .  . tlb .  .  . dwf .
        tw5 .  . dlm .  .  . tw6 .  .  . dln .  .  tw7
      ''',
      // A number of extension methods are provided for concise track sizing
      columnSizes: repeat(trackCount, [36.px]),
      rowSizes: repeat(trackCount, [36.px]),
      children: [
        // First, square bases
        for (int i = 0; i < trackCount; i++)
          for (int j = 0; j < trackCount; j++)
            const StandardSquare()
                .withGridPlacement(columnStart: i, rowStart: j),

        // Then put bonuses on top
        const StartingSquare().inGridArea('★'),
        for (int i = 0; i < doubleLetterCount; i++)
          const DoubleLetterSquare().inGridArea('dl${i.toRadixString(36)}'),
        for (int i = 0; i < doubleWordCount; i++)
          const DoubleWordSquare().inGridArea('dw${i.toRadixString(36)}'),
        for (int i = 0; i < tripleLetterCount; i++)
          const TripleLetterSquare().inGridArea('tl${i.toRadixString(36)}'),
        for (int i = 0; i < tripleWordCount; i++)
          const TripleWordSquare().inGridArea('tw${i.toRadixString(36)}'),

        // Then place tiles on top of those
        for (final tile in tiles)
          LetterTile(letter: tile.letter).withGridPlacement(
            columnStart: tile.col,
            rowStart: tile.row,
          ),
      ],
    );
  }
}

const orangeSquareBackground = Color(0xfffd8e73);
const magentaSquareBackground = Color(0xfff01c7a);
const lightBlueSquareBackground = Color(0xff8ecafc);
const darkBlueSquareBackground = Color(0xff1375b0);

class LetterTile extends StatelessWidget {
  LetterTile({Key? key, required String letter})
      : letter = letter.toUpperCase(),
        super(key: key);

  final String letter;

  double get lockupRightPadding {
    switch (letter) {
      case 'M':
        return 1.5;
      case 'G':
        return 3;
      default:
        return 1;
    }
  }

  double get pointsRightPadding {
    switch (letter) {
      case 'G':
        return 0;
      case 'A':
      case 'M':
        return 1;
      case 'T':
        return 3;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: SizedBox.expand(
        child: InnerShadow(
          offset: const Offset(0, -1.5),
          blurX: 0.8,
          blurY: 1,
          color: Colors.black.withOpacity(.25),
          child: _buildTileContents(),
        ),
      ),
    );
  }

  DecoratedBox _buildTileContents() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xfffaeac2),
        border: Border.all(
          color: Colors.black.withAlpha(18),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          right: lockupRightPadding + 0.3,
          bottom: 0.8,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildLetterLabel(),
            _buildPointLabel(),
          ],
        ),
      ),
    );
  }

  Text _buildLetterLabel() {
    return Text(
      letter,
      style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Positioned _buildPointLabel() {
    return Positioned(
      right: pointsRightPadding,
      bottom: 1,
      child: Text(
        '${letterPointMapping[letter]}',
        style: GoogleFonts.nunitoSans(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class StartingSquare extends Square {
  const StartingSquare({Key? key})
      : super(
          key: key,
          label: '★',
          color: orangeSquareBackground,
          edgeInsetsOverride: const EdgeInsets.only(left: 0.2, bottom: 0.5),
          labelFontSizeOverride: 14,
        );
}

class DoubleLetterSquare extends Square {
  const DoubleLetterSquare({Key? key})
      : super(
          key: key,
          label: 'DL',
          color: lightBlueSquareBackground,
        );
}

class DoubleWordSquare extends Square {
  const DoubleWordSquare({Key? key})
      : super(
          key: key,
          label: 'DW',
          color: orangeSquareBackground,
        );
}

class TripleLetterSquare extends Square {
  const TripleLetterSquare({Key? key})
      : super(
          key: key,
          label: 'TL',
          color: darkBlueSquareBackground,
        );
}

class TripleWordSquare extends Square {
  const TripleWordSquare({Key? key})
      : super(
          key: key,
          label: 'TW',
          color: magentaSquareBackground,
        );
}

class StandardSquare extends Square {
  const StandardSquare({Key? key})
      : super(
          key: key,
          color: const Color(0xffe7eaef),
        );
}

class Square extends StatelessWidget {
  const Square({
    Key? key,
    required this.color,
    this.label,
    this.labelFontSizeOverride,
    this.edgeInsetsOverride,
  }) : super(key: key);

  final Color color;
  final String? label;
  final double? labelFontSizeOverride;
  final EdgeInsets? edgeInsetsOverride;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InnerShadow(
        offset: const Offset(0, 0.5),
        blurX: 0.8,
        blurY: 0.7,
        color: Colors.black.withOpacity(.25),
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.elliptical(6, 4)),
            ),
            child: _buildLabel(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    final label = this.label;
    if (label == null) return const SizedBox();

    return Center(
      child: Padding(
        padding:
            edgeInsetsOverride ?? const EdgeInsets.only(top: 1.0, left: 0.5),
        child: Text(
          label,
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w500,
            fontSize: labelFontSizeOverride ?? 12,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class TileInfo {
  TileInfo(this.letter, this.col, this.row)
      : points = letterPointMapping[letter]!;

  final String letter;
  final int col;
  final int row;
  final int points;

  @override
  String toString() => '$letter@($col, $row)=$points';
}

const letterPointMapping = {
  'A': 1,
  'B': 3,
  'C': 3,
  'D': 2,
  'E': 1,
  'F': 4,
  'G': 2,
  'H': 4,
  'I': 1,
  'J': 8,
  'K': 5,
  'L': 1,
  'M': 3,
  'N': 1,
  'O': 1,
  'P': 3,
  'Q': 10,
  'R': 1,
  'S': 1,
  'T': 1,
  'U': 1,
  'V': 4,
  'W': 4,
  'X': 8,
  'Y': 4,
  'Z': 10,
};

Iterable<TileInfo> parseTiles(String tileLayout) sync* {
  final rows = LineSplitter.split(tileLayout)
      .map((row) => row.trim())
      .where((row) => row.isNotEmpty)
      .toList();
  for (int i = 0; i < rows.length; i++) {
    final row = rows[i];
    final columns = row.split(RegExp(r'\s+'));
    for (int j = 0; j < columns.length; j++) {
      final cell = columns[j];
      if (cell == '.') continue;

      yield TileInfo(cell, j, i);
    }
  }
}
