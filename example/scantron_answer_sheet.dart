// Inspired by the excellent work of Jon Kantner:
// https://codepen.io/jkantner/pen/MGMMVo

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'support/decoration.dart';
import 'support/link.dart';

void main() {
  runApp(ScantronAnswerSheetApp());
}

const questionCount = 50;

/// Used by a couple of extensions on num, defined below
const remUnit = 16.0;
const scantronGreen = Color(0xff20b090);
final choiceLabelScaleFactor = 1.9;
final questionGroupingBorderRadius = 0.375.rem;
final scoreGridRadius = Radius.circular(0.5.rem);

/// Column/row sizes, used by a couple of widgets
const questionLabels = ['A', 'B', 'C', 'D', 'E'];
final questionGridColumnSizes = [
  fixed(2.rem), // Question number
  // A, B, C, D, E, (blank)
  ...repeat(questionLabels.length + 1, [fixed(2.5.rem)]),
];
final questionGridRowHeight = 1.25.rem;

final rootTextStyle = TextStyle(
  fontFamily: 'Helvetica Neue',
  fontFamilyFallback: ['Helvetica'],
  fontSize: 1.rem,
  color: scantronGreen,
);
final bubbleHeaderTextStyle = rootTextStyle.copyWith(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
final instructionsTextStyle = rootTextStyle.copyWith(
  fontSize: 0.625.rem,
  fontWeight: FontWeight.bold,
  height: 1.4,
);
final tagSeparatedTextStyle = TextStyle(
  fontSize: 3.rem,
  height: 0,
);
final questionHeaderTextStyle = TextStyle(
  fontSize: 0.8.rem,
  letterSpacing: 0.05.rem,
);

/// Top-level widget, composing the components of the answer sheet.
class ScantronAnswerSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: rootTextStyle,
      child: Builder(
        builder: (context) => SizedBox(
          height: 56 * questionGridRowHeight + 76,
          child: LayoutGrid(
            gridFit: GridFit.loose,
            areas: '''
              .      .       score     .   .        part
              margin barcode score     .   .        part
              margin barcode questions tags reorder metadata
            ''',
            columnSizes: [
              fixed(3.rem), // help and copyright (margin)
              fixed(2.625.rem), // barcode
              auto, // questions
              auto, // test tags
              fixed(2.6.rem), // call to reorder
              auto, // metadata and legend
            ],
            rowSizes: [
              fixed(3.5.rem),
              auto,
              auto,
            ],
            children: [
              _buildMargin(context).inGridArea('margin'),
              _buildBarcode().inGridArea('barcode'),
              _buildScore().inGridArea('score'),
              _buildQuestions().inGridArea('questions'),
              _buildTestTags().inGridArea('tags'),
              _buildReorder().inGridArea('reorder'),
              _buildPartLabel().inGridArea('part'),
              _buildMetadataAndInstructions().inGridArea('metadata'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMargin(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '© SCANTRON CORPORATION 2007\nALL RIGHTS RESERVED',
            style: TextStyle(fontSize: 0.6.rem, letterSpacing: -0.03.rem),
          ),
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Customer Service\n',
                      style: TextStyle(
                        fontSize: .9.rem,
                        letterSpacing: 0.04.rem,
                      ),
                    ),
                    WidgetSpan(
                      child: UrlLink(
                        'tel:1-800-SCANTRON',
                        style: TextStyle(
                          fontSize: .9.rem,
                          letterSpacing: 0.04.rem,
                        ),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 1.8.rem),
              Container(
                decoration: ArrowBoxDecoration(
                  headLength: 4.75.rem,
                  tailLength: 4.75.rem,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.4.rem),
                  child: Text(
                    'FEED THIS DIRECTION',
                    style: TextStyle(
                      fontSize: .75.rem,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontSize: 0.75.rem),
              children: [
                TextSpan(
                  text: '8012 4207 599',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' 16'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcode() {
    return SizedBox(
      width: double.infinity,
      height: (questionCount + 4 + 3) * questionGridRowHeight,
      child: Padding(
        padding: EdgeInsets.only(right: 0.6.rem),
        child: QuestionBarcodes(
          pattern: [
            for (int i = 0; i < 4; i++) BarcodeStripeType.short,
            BarcodeStripeType.blank,
            BarcodeStripeType.long,
            for (int i = 0; i < questionCount - 1; i++) BarcodeStripeType.short,
            BarcodeStripeType.long,
          ],
        ),
      ),
    );
  }

  Widget _buildScore() {
    return ScoreGrid();
  }

  Widget _buildQuestions() {
    return QuestionGrid(
      questionCount: questionCount,
    );
  }

  Widget _buildTestTags() {
    return Padding(
      padding: EdgeInsets.only(top: questionGridRowHeight),
      child: RotatedBox(
        quarterTurns: 1,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'SHORT ESSAY '),
              WidgetSpan(child: Text('•', style: tagSeparatedTextStyle)),
              TextSpan(text: ' COMPLETION '),
              WidgetSpan(child: Text('•', style: tagSeparatedTextStyle)),
              TextSpan(text: ' MULTIPLE CHOICE '),
              WidgetSpan(child: Text('•', style: tagSeparatedTextStyle)),
              TextSpan(text: ' MATCHING'),
            ],
          ),
          style: TextStyle(
            fontSize: 1.8.rem,
            letterSpacing: 0.08.rem,
            color: scantronGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReorder() {
    return RotatedBox(
      quarterTurns: 1,
      // Transform squishes the text a bit
      child: Transform(
        transform: Matrix4.diagonal3Values(0.85, 1.25, 1.0),
        child: SizedBox.expand(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('REORDER ONLINE'),
              SizedBox(width: 1.rem),
              UrlLink('https://www.scantronforms.com'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartLabel() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.rem),
      child: Center(
        child: Text(
          'PART 1',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMetadataAndInstructions() {
    return RotatedBox(
      quarterTurns: 1,
      child: ScantronMetadataContainer(),
    );
  }
}

enum BarcodeStripeType {
  blank,
  short,
  long,
}

class QuestionBarcodes extends StatelessWidget {
  const QuestionBarcodes({
    Key key,
    @required this.pattern,
  }) : super(key: key);
  final List<BarcodeStripeType> pattern;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BarcodePainter(pattern: pattern),
    );
  }
}

class BarcodePainter extends CustomPainter {
  BarcodePainter({@required this.pattern});
  final List<BarcodeStripeType> pattern;

  Rect rectForStripe(BarcodeStripeType type) {
    switch (type) {
      case BarcodeStripeType.long:
        return Offset(0, -2) & Size(double.infinity, 0.8.rem);

      case BarcodeStripeType.short:
        return Offset.zero & Size(double.infinity, 0.18.rem);

      default:
        return Rect.zero;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    for (int i = 0; i < pattern.length; i++) {
      if (pattern[i] != BarcodeStripeType.blank) {
        final cellRect = rectForStripe(pattern[i]);
        final adjustedCellRect = cellRect
            .shift(Offset(0, i * questionGridRowHeight))
            .copyWith(width: size.width);

        canvas.drawRect(adjustedCellRect, fill);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScoreGrid extends StatelessWidget {
  const ScoreGrid({
    Key key,
    this.includeHeader = true,
    this.includeEmptyLeadingColumn = true,
    this.finalScore,
    this.filledScoreCells = const {},
  }) : super(key: key);

  final bool includeHeader;
  final bool includeEmptyLeadingColumn;
  final String finalScore;
  final Set<int> filledScoreCells;

  int get firstScoreRow => includeHeader ? 1 : 0;
  int get firstScoreColumn => includeEmptyLeadingColumn ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      gridFit: GridFit.expand,
      columnSizes: questionGridColumnSizes,
      rowSizes: [
        if (includeHeader) auto,
        ...repeat(4, [questionGridRowHeight.px])
      ],
      children: [
        ..._buildScoreCells(),
        if (includeHeader) _buildHeader(),
        ..._buildOutlines(),
        if (finalScore != null) _buildFinalScore(),
      ],
    );
  }

  Widget _buildHeader() {
    return SizedBox.expand(
      child: Heading('SUBJECTIVE SCORE\nINSTRUCTOR USE ONLY'),
    ).withGridPlacement(columnStart: 1, columnSpan: 6, rowStart: 0);
  }

  List<Widget> _buildScoreCells() {
    final rows = [
      [100, 90, 80, 70, 60],
      [50, 40, 30, 20, 10],
      [9, 8, 7, 6, 5],
      [4, 3, 2, 1, 0],
    ];
    final colStart = firstScoreColumn;
    final rowStart = firstScoreRow;

    return [
      for (int i = 0; i < rows.length; i++)
        for (int j = 0; j < 5; j++)
          QuestionChoice(
            label: rows[i][j].toString(),
            filled: filledScoreCells.contains(rows[i][j]),
          ).withGridPlacement(
            columnStart: colStart + j,
            rowStart: rowStart + i,
          ),
    ];
  }

  List<Widget> _buildOutlines() {
    return [
      // Outline around entire grid
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(scoreGridRadius),
          border: Border.all(color: scantronGreen),
        ),
      ).withGridPlacement(
        columnStart: firstScoreColumn,
        columnSpan: 6,
        rowStart: 0,
        rowSpan: includeHeader ? 5 : 4,
      ),
      // Single line on right edge of choices
      Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: scantronGreen)),
        ),
      ).withGridPlacement(
        columnStart: firstScoreColumn,
        columnSpan: 5,
        rowStart: firstScoreRow,
        rowSpan: 4,
      )
    ];
  }

  Widget _buildFinalScore() {
    return SizedBox();
  }
}

class QuestionGrid extends StatelessWidget {
  QuestionGrid({
    @required this.questionCount,
  });

  final int questionCount;

  @override
  Widget build(BuildContext context) {
    // TODO(shyndman): This would be better with a template
    return LayoutGrid(
      // ordinals + questions + blank
      columnSizes: questionGridColumnSizes,
      // header + pre-question + questions
      rowSizes: repeat(1 + 1 + questionCount, [fixed(questionGridRowHeight)]),
      children: [
        ..._buildHeaderRow(),
        ..._buildPreQuestionRow(),
        ..._buildQuestions(),
        ..._buildQuestionGroupings(),
      ],
    );
  }

  List<Widget> _buildHeaderRow() {
    return [
      QuestionHeader(label: '(T)')
          .withGridPlacement(columnStart: 1, rowStart: 0),
      QuestionHeader(label: '(F)')
          .withGridPlacement(columnStart: 2, rowStart: 0),
      QuestionHeader(label: 'KEY', bold: true)
          .withGridPlacement(columnStart: 5, rowStart: 0),
    ];
  }

  List<Widget> _buildPreQuestionRow() {
    return [
      QuestionChoice(label: '%', italic: true)
          .withGridPlacement(columnStart: 1, rowStart: 1),
      QuestionChoice(label: '2', italic: true)
          .withGridPlacement(columnStart: 2, rowStart: 1),
      QuestionChoice(label: '3', italic: true)
          .withGridPlacement(columnStart: 3, rowStart: 1),
      QuestionChoice(label: '5', italic: true)
          .withGridPlacement(columnStart: 5, rowStart: 1),
    ];
  }

  List<Widget> _buildQuestions() {
    final firstRow = 2;
    return [
      for (int i = 0; i < questionCount; i++)
        QuestionNumber(label: i + 1)
            .withGridPlacement(columnStart: 0, rowStart: firstRow + i),
      for (int i = 0; i < questionCount; i++)
        for (int j = 0; j < questionLabels.length; j++)
          QuestionChoice(label: questionLabels[j]).withGridPlacement(
            columnStart: 1 + j,
            rowStart: firstRow + i,
          ),
    ];
  }

  /// Lined brackets around groups of questions
  List<Widget> _buildQuestionGroupings() {
    final firstRow = 2;
    return [
      if (questionCount > 20)
        QuestionGrouping().withGridPlacement(
          columnStart: 0,
          columnSpan: 6,
          rowStart: firstRow + 10,
          rowSpan: 10,
        ),
      if (questionCount > 40)
        QuestionGrouping().withGridPlacement(
          columnStart: 0,
          columnSpan: 6,
          rowStart: firstRow + 30,
          rowSpan: 10,
        ),
    ];
  }
}

class QuestionHeader extends StatelessWidget {
  const QuestionHeader({
    Key key,
    this.label,
    this.bold = false,
  }) : super(key: key);

  final String label;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = questionHeaderTextStyle;
    return SizedBox.expand(
      child: Center(
        child: Text(
          label,
          style: bold ? style.copyWith(fontWeight: FontWeight.bold) : style,
        ),
      ),
    );
  }
}

/// The number next to a question
class QuestionNumber extends StatelessWidget {
  const QuestionNumber({Key key, this.label}) : super(key: key);
  final int label;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.only(right: 0.25.rem),
        child: Text(
          label.toString(),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 1.rem,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// One of a question's choices (ie, A, B, C, etc)
class QuestionChoice extends StatelessWidget {
  const QuestionChoice({
    Key key,
    this.label,
    this.margin,
    this.filled = false,
    this.italic = false,
  }) : super(key: key);

  final String label;
  final bool filled;
  final bool italic;
  final EdgeInsets margin;

  double get fontSize => label.length == 3
      ? 0.74.rem
      : label.length == 2
          ? 0.85.rem
          : 0.95.rem;

  EdgeInsets get labelPadding => label.length == 3
      ? EdgeInsets.symmetric(vertical: 0.075.rem)
      : EdgeInsets.all(0.05.rem);

  EdgeInsets get effectiveBoxMargin =>
      margin ??
      EdgeInsets.symmetric(
        horizontal: 0.45.rem,
        vertical: 0.37.rem,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Green edges
        Container(
          margin: effectiveBoxMargin,
          decoration: BoxDecoration(
            border: Border.all(color: scantronGreen),
          ),
        ),
        Transform.scale(
          scale: choiceLabelScaleFactor,
          child: Container(
            color: Colors.white,
            padding: labelPadding,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize / choiceLabelScaleFactor,
                fontWeight: FontWeight.bold,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ),
        if (filled)
          Container(
            margin: effectiveBoxMargin,
            color: scantronGreen,
          ),
      ],
    );
  }
}

class QuestionGrouping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: QuestionGroupingPainter(),
      ),
    );
  }
}

class ScantronMetadataContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      areas: '''
          instructions sheet_meta   score_tally
          instructions student_meta score_tally
        ''',
      columnSizes: [1.5.fr, 1.5.fr, 0.75.fr],
      rowSizes: [auto, auto],
      columnGap: 1.rem,
      children: [
        ScantronInstructions().inGridArea('instructions'),
        ScantronLogoAndSheetMetadata().inGridArea('sheet_meta'),
        ScantronStudentMetadata().inGridArea('student_meta'),
        ScantronScoreTally().inGridArea('score_tally'),
      ],
    );
  }
}

class ScantronInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: instructionsTextStyle,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: scantronGreen),
          borderRadius: BorderRadius.all(scoreGridRadius),
        ),
        clipBehavior: Clip.hardEdge,
        child: _buildGrid(),
      ),
    );
  }

  LayoutGrid _buildGrid() {
    return LayoutGrid(
      gridFit: GridFit.loose,
      areas: '''
          header  header
          student teacher
        ''',
      columnSizes: [1.fr, 1.fr],
      rowSizes: [
        auto,
        auto,
      ],
      children: [
        _buildHeader().inGridArea('header'),
        _buildStudentInstructions().inGridArea('student'),
        _buildTeacherInstructions().inGridArea('teacher'),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: scantronGreen,
      child: Heading('IMPORTANT'),
    );
  }

  Widget _buildStudentInstructions() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: scantronGreen),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 0.25.rem,
        vertical: 0.125.rem,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: PencilBoxDecoration(
              headLength: 1.3.rem,
              tailLength: 0.9.rem,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.4.rem),
              child: Text(
                'USE NO. 2 PENCIL ONLY',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.normal,
                  height: 1.1,
                ),
              ),
            ),
          ),
          Bullet(child: Text('MAKE DARK MARKS')),
          Bullet(
            child: Text('ERASE COMPLETELY\nTO CHANGE'),
          ),
          Bullet(
            child: Row(
              children: [
                Expanded(child: Text('EXAMPLE:')),
                ..._buildExampleChoices(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExampleChoices() {
    return [
      for (int i = 0; i < questionLabels.length; i++)
        SizedBox(
          width: 26,
          height: 13,
          child: Transform.scale(
            scale: 0.6,
            child: QuestionChoice(
              margin: EdgeInsets.symmetric(vertical: 0.15.rem),
              label: questionLabels[i],
              filled: i == 1, // fill in B
            ),
          ),
        ),
    ];
  }

  Widget _buildTeacherInstructions() {
    return Padding(
      padding: EdgeInsets.only(
        left: 0.4.rem,
        right: 0.25.rem,
        top: 0.125.rem,
        bottom: 0.3125.rem,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TO USE SUBJECTIVE\nSCORE FEATURE:',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.5,
            ),
          ),
          Column(
            children: [
              Bullet(child: Text('Make total possible subjective points')),
              Bullet(child: Text('Only one mark per line on key')),
              Bullet(child: Text('163 points maximum')),
            ],
          ),
          _buildTeacherExample(),
        ],
      ),
    );
  }

  Widget _buildTeacherExample() {
    return Row(
      children: [
        Flexible(child: Text('EXAMPLE OF STUDENT SCORE:')),
        Transform.scale(
          scale: 0.5,
          origin: Offset(0, 0),
          child: ScoreGrid(
            includeEmptyLeadingColumn: false,
            includeHeader: false,
            filledScoreCells: {100, 20, 5},
            finalScore: '125',
          ),
        ),
      ],
    );
  }
}

class ScantronLogoAndSheetMetadata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        children: [
          Transform(
            transform: Matrix4.diagonal3Values(1, 1.5, 1),
            child: Text(
              'SCANTRON®',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.825.rem,
              ),
            ),
          ),
          Text('FORM NO. 883-E'),
        ],
      ),
      Text(
        'FOR USE ON\nTEST SCORING\nMACHINE ONLY',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 0.9.rem,
          fontStyle: FontStyle.italic,
        ),
      )
    ]);
  }
}

class ScantronStudentMetadata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scantronGreen),
        borderRadius: BorderRadius.all(scoreGridRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutGrid(
        areas: '''
          nameLabel    name    name        name
          subjectLabel subject testNoLabel testLabel
          dateLabel    date    periodLabel period
        ''',
        columnGap: 10,
        columnSizes: repeat(4, [auto]),
        rowSizes: repeat(3, [auto]),
        children: [
          // Headings
          Heading('NAME').inGridArea('nameLabel'),
          Heading('SUBJECT').inGridArea('subjectLabel'),
          Heading('DATE').inGridArea('dateLabel'),
          Heading('TEST NO.').inGridArea('testNoLabel'),
          Heading('PERIOD').inGridArea('periodLabel'),

          // Lines
          ..._buildRowLines(),
        ],
      ),
    );
  }

  List<Widget> _buildRowLines() {
    return [
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: scantronGreen),
          ),
        ),
      ).withGridPlacement(columnStart: 0, columnSpan: 4, rowStart: 1),
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: scantronGreen),
          ),
        ),
      ).withGridPlacement(columnStart: 0, columnSpan: 4, rowStart: 2),
    ];
  }
}

class ScantronScoreTally extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scantronGreen),
        borderRadius: BorderRadius.all(scoreGridRadius),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutGrid(
        areas: '''
          header header
          part1  score1
          part2  score2
          part3  score3
          total  total_score
        ''',
        columnSizes: repeat(2, [auto]),
        rowSizes: repeat(5, [auto]),
        children: [
          _buildHeader().inGridArea('header'),
          for (int i = 1; i <= 3; i++) ...[
            SizedBox.expand(child: Text('PART $i', textAlign: TextAlign.center))
                .inGridArea('part$i'),
            Container().inGridArea('score$i'),
          ],
          _buildTotal().inGridArea('total'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox.expand(
      child: Container(
        color: scantronGreen,
        child: Heading('TEST RECORD'),
      ),
    );
  }

  Widget _buildTotal() {
    return SizedBox.expand(
      child: Text(
        'TOTAL',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading(
    this.label, {
    Key key,
    this.topLeft = false,
    this.topRight = false,
    this.bottomRight = false,
    this.bottomLeft = false,
  }) : super(key: key);

  final String label;
  final bool topLeft;
  final bool topRight;
  final bool bottomRight;
  final bool bottomLeft;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: scantronGreen,
          borderRadius: BorderRadius.only(
            topLeft: topLeft ? scoreGridRadius : Radius.zero,
            topRight: topRight ? scoreGridRadius : Radius.zero,
            bottomRight: bottomRight ? scoreGridRadius : Radius.zero,
            bottomLeft: bottomLeft ? scoreGridRadius : Radius.zero,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.75.rem, vertical: 0.25.rem),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: bubbleHeaderTextStyle,
        ),
      ),
    );
  }
}

class Bullet extends StatelessWidget {
  const Bullet({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('•'),
        SizedBox(width: 4),
        Flexible(child: child),
      ],
    );
  }
}

class QuestionGroupingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = questionGroupingBorderRadius;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(radius, 0)
      ..arcToPoint(Offset(0, radius),
          radius: Radius.circular(radius), clockwise: false)
      ..lineTo(0, size.height - radius)
      ..arcToPoint(Offset(radius, size.height),
          radius: Radius.circular(radius), clockwise: false)
      ..lineTo(size.width, size.height);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = scantronGreen
        ..strokeWidth = 0.125.rem,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Draws a fancy arrow around the [DecoratedBox]'s child.
class ArrowBoxDecoration extends SimpleDecoration {
  ArrowBoxDecoration({
    @required this.headLength,
    @required this.tailLength,
  });

  final double headLength;
  final double tailLength;

  @override
  EdgeInsetsGeometry get padding =>
      EdgeInsets.fromLTRB(headLength, 0, tailLength, 0);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = scantronGreen
      ..isAntiAlias = true;
    final size = configuration.size;

    final pointLength = 1.2 * headLength / 3;
    final featherLength = 3 * tailLength / 5;
    final featherStraightLength = 1.3 * tailLength / 3;
    final featherInsetLength = tailLength / 5;

    final shaftWidth = size.height / 4;
    final shaftTop = (size.height / 2) - shaftWidth / 2;
    final shaftBottom = shaftTop + shaftWidth;

    final headPath = Path()
      // The point of the arrow
      ..moveTo(0, size.height / 2)
      ..lineTo(pointLength, 0)
      ..lineTo(pointLength, shaftTop)
      ..lineTo(headLength, shaftTop)
      ..lineTo(headLength, shaftBottom)
      ..lineTo(pointLength, shaftBottom)
      ..lineTo(pointLength, size.height);

    final tailBox =
        Rect.fromLTWH(size.width - tailLength, 0, tailLength, size.height);
    final tailPath = Path()
      // Top of the
      ..moveTo(tailBox.left, shaftTop)
      ..lineTo(tailBox.right - featherLength, shaftTop)
      ..lineTo(tailBox.right - featherStraightLength, 0)
      ..lineTo(tailBox.right, 0)
      ..lineTo(tailBox.right - featherInsetLength, size.height / 2)
      ..lineTo(tailBox.right, size.height)
      ..lineTo(tailBox.right - featherStraightLength, size.height)
      ..lineTo(tailBox.right - featherLength, shaftBottom)
      ..lineTo(tailBox.left, shaftBottom);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(headPath, paint);
    canvas.drawPath(tailPath, paint);
    canvas.restore();
  }
}

/// Draws a pencil around the [DecoratedBox]'s child.
class PencilBoxDecoration extends SimpleDecoration {
  PencilBoxDecoration({
    @required this.headLength,
    @required this.tailLength,
  });

  final double headLength;
  final double tailLength;

  @override
  EdgeInsetsGeometry get padding =>
      EdgeInsets.fromLTRB(headLength, 0, tailLength, 0);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = scantronGreen;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = scantronGreen;

    final size = configuration.size;
    final leadLength = 0.4 * headLength;
    final pointLength = 3 * headLength / 4;
    final eraserLength = 4 * tailLength / 7;
    final eraserHolderLength = 4 * tailLength / 7;

    final pointPath = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(pointLength, 0)
      ..lineTo(pointLength, size.height)
      ..lineTo(0, size.height / 2);
    canvas.drawPath(pointPath.shift(offset), stroke);

    canvas.save();
    canvas.clipPath(pointPath.shift(offset));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, leadLength, size.height).shift(offset), fill);
    canvas.restore();

    final outlineRect = Rect.fromLTWH(
      pointLength,
      0,
      size.width - pointLength,
      size.height,
    );
    canvas.drawRect(
      outlineRect.shift(offset),
      stroke,
    );

    final eraserRect =
        Rect.fromLTWH(size.width - eraserLength, 0, eraserLength, size.height);
    canvas.drawRect(
      eraserRect.shift(offset),
      fill,
    );

    final eraserHolderRect = Rect.fromLTWH(eraserRect.left - eraserHolderLength,
        0, eraserHolderLength, size.height);
    canvas.drawRect(
      eraserHolderRect.shift(offset),
      stroke,
    );
  }
}

/// Little extension to support scaling
extension on num {
  double get rem => this.toDouble() * remUnit;
}

/// Little extension to support simple copies
extension on Rect {
  Rect copyWith({
    double left,
    double top,
    double width,
    double height,
  }) {
    return Rect.fromLTWH(
      left ?? this.left,
      top ?? this.top,
      width ?? this.width,
      height ?? this.height,
    );
  }
}

/// Boilerplate
class ScantronAnswerSheetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: WidgetsApp(
        title: 'Scantron Answer Sheet',
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        builder: (_, __) {
          return Center(
            child: SizedBox(
              width: 416,
              child: ScantronInstructions(),
            ),
          );

          // return SingleChildScrollView(
          //   child: Center(
          //     child: RotatedBox(
          //       quarterTurns: 3,
          //       child: ScantronAnswerSheet(),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
