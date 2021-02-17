import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'rally/model.dart';
import 'rally/theme.dart';
import 'rally/widgets.dart';
import 'support/animated_viewport.dart';

void main() {
  runApp(App(animated: false));
}

class App extends StatelessWidget {
  const App({
    Key key,
    this.animated = false,
  }) : super(key: key);

  final bool animated;

  @override
  Widget build(BuildContext context) {
    final layout = animated
        ? AnimatedViewport(builder: (_, viewportSize, scale) {
            return ResponsiveLayout(
                viewportWidth: viewportSize.width, scale: scale);
          })
        : LayoutBuilder(builder: (_, constraints) {
            return ResponsiveLayout(viewportWidth: constraints.maxWidth);
          });

    return MaterialApp(
      color: Colors.white,
      theme: ThemeData.dark().copyWith(
        textTheme: rallyTextTheme,
      ),
      home: DefaultTextStyle(
        style: rallyTextTheme.bodyText2,
        child: layout,
      ),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key key,
    this.viewportWidth,
    this.scale = 1,
  }) : super(key: key);

  final double viewportWidth;
  final double scale;

  ResponsiveConfiguration computeResponsiveConfig() {
    if (viewportWidth > 1194) {
      // Desktop
      return ResponsiveConfiguration(
        areas: '''
          nav acct acct acct acct bill bill bill bill alrt alrt alrt
          nav bdgt bdgt bdgt bdgt bdgt bdgt bdgt bdgt alrt alrt alrt
        ''',
        columnSizes: repeat(12, [1.fr]),
        rowSizes: [
          auto,
          auto,
        ],
        columnGap: 32,
        rowGap: 36,
        padding: EdgeInsets.only(left: 36, right: 36, top: 36),
        alertsCardAxis: Axis.vertical,
      );
    } else if (viewportWidth > 800) {
      // Tablet
      return ResponsiveConfiguration(
        areas: '''
          nav nav alrt alrt alrt alrt alrt alrt alrt alrt alrt alrt
          nav nav acct acct acct acct acct bill bill bill bill bill
          nav nav bdgt bdgt bdgt bdgt bdgt bdgt bdgt bdgt bdgt bdgt
        ''',
        columnSizes: repeat(12, [1.fr]),
        rowSizes: [
          auto,
          auto,
          auto,
        ],
        columnGap: 28,
        rowGap: 32,
        padding: EdgeInsets.only(left: 28, right: 28, top: 32),
        visibleAccountCount: 3,
        alertsCardAxis: Axis.horizontal,
        visibleAlertCount: 3,
      );
    } else {
      // Small mobile
      return ResponsiveConfiguration(
        areas: '''
          nav  nav  nav  nav
          alrt alrt alrt alrt
          acct acct acct acct
          bill bill bill bill
          bdgt bdgt bdgt bdgt
        ''',
        columnSizes: repeat(4, [1.fr]),
        rowSizes: [
          auto,
          auto,
          auto,
          auto,
          auto,
        ],
        columnGap: 16,
        rowGap: 20,
        padding: EdgeInsets.only(left: 16, right: 16, top: 12),
        alertsCardAxis: Axis.horizontal,
        visibleAlertCount: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = computeResponsiveConfig();
    return Container(
      color: backgroundColor,
      padding: config.padding,
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return SizedBox(
              width: constraints.biggest.width,
              child: LayoutGrid(
                gridFit: GridFit.loose,
                areas: config.areas,
                columnSizes: config.scaleColumnSizes(scale),
                rowSizes: config.scaleRowSizes(scale),
                columnGap: config.columnGap,
                rowGap: config.rowGap,
                debugLabel: 'app',
                children: [
                  Navigation().inGridArea('nav'),
                  AccountsSummaryCard(
                    model: demoAccounts,
                    visibleAccountCount: config.visibleAccountCount,
                  ).inGridArea('acct'),
                  AccountsSummaryCard(
                    model: demoBills,
                    visibleAccountCount: config.visibleAccountCount,
                  ).inGridArea('bill'),
                  BudgetSummaryCard(
                    budget: demoBudget,
                  ).inGridArea('bdgt'),
                  AlertsCard(
                    alerts: demoAlerts,
                    alertCount: config.visibleAlertCount,
                    axis: config.alertsCardAxis,
                  ).inGridArea('alrt'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ResponsiveConfiguration {
  ResponsiveConfiguration({
    this.areas,
    this.columnSizes,
    this.rowSizes,
    this.columnGap = 0,
    this.rowGap = 0,
    this.padding = EdgeInsets.zero,
    this.visibleAccountCount = 4,
    this.alertsCardAxis = Axis.vertical,
    this.visibleAlertCount,
  });

  final String areas;
  final List<TrackSize> columnSizes;
  final List<TrackSize> rowSizes;
  final double columnGap;
  final double rowGap;
  final EdgeInsets padding;
  final int visibleAccountCount;

  /// The main axis along which alerts are displayed
  final Axis alertsCardAxis;

  /// If `null`, all alerts are shown
  final int visibleAlertCount;

  List<TrackSize> scaleColumnSizes(double scale) {
    return columnSizes
        .map((t) => t is FixedTrackSize ? fixed(t.sizeInPx * scale) : t)
        .toList();
  }

  List<TrackSize> scaleRowSizes(double scale) {
    return rowSizes
        .map((t) => t is FixedTrackSize ? fixed(t.sizeInPx * scale) : t)
        .toList();
  }
}
