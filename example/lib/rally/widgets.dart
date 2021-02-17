/// A set of widgets based on the Rally study from the Material Design team.
///
/// https://material.io/design/material-studies/rally.html#typography
library rally;

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:money2/money2.dart';

import 'model.dart';
import 'theme.dart';

class Navigation extends StatelessWidget {
  final _inactiveSectionIcons = [
    Icons.attach_money,
    Icons.money_off,
    Icons.bar_chart,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(color: Colors.red),
        ),
        Icon(Icons.pie_chart),
        for (final icon in _inactiveSectionIcons)
          Padding(
            padding: const EdgeInsets.only(top: 72.0),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
      ],
    );
  }
}

class AccountsSummaryCard extends StatelessWidget {
  const AccountsSummaryCard({
    Key key,
    this.model,
    this.visibleAccountCount,
  }) : super(key: key);

  final AccountCategory model;
  final int visibleAccountCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: cardVPadding,
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: cardHPadding,
              child: CardHeader(
                title: model.name,
                leadingAmount: model.absTotalAmount.format(currencyFormat),
              ),
            ),
            AccountCategoryStackedColorBar(category: model),
            SizedBox(height: 8),
            Padding(
              padding: cardHPadding,
              child: AccountList(
                category: model,
                visibleAccountCount: visibleAccountCount,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SeeAllButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountCategoryStackedColorBar extends StatelessWidget {
  const AccountCategoryStackedColorBar({
    Key key,
    this.category,
  }) : super(key: key);

  final AccountCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < category.accounts.length; i++)
          Expanded(
            flex: category.accounts[i].amount.minorUnits.toInt().abs(),
            child: Container(
              height: 2,
              color: category.colorAtIndex(i),
            ),
          ),
      ],
    );
  }
}

class AccountList extends StatelessWidget {
  const AccountList({
    Key key,
    @required this.category,
    @required this.visibleAccountCount,
  }) : super(key: key);

  final AccountCategory category;
  final int visibleAccountCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < visibleAccountCount; i++)
          AccountTile(
            account: category.accounts[i],
            highlightColor: category.colorAtIndex(i),
          ),
      ],
    );
  }
}

class AccountTile extends StatelessWidget {
  const AccountTile({
    Key key,
    this.account,
    this.highlightColor,
  }) : super(key: key);

  final Account account;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: backgroundColor, width: 1.5)),
      ),
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            color: highlightColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: TileLabelLockup(name: account.name, hint: account.hint),
          ),
          TileCurrency(
            amount: account.amount,
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class TileCurrency extends StatelessWidget {
  const TileCurrency({
    Key key,
    @required this.amount,
    this.trailing,
  }) : super(key: key);

  final Money amount;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          amount.format(currencyFormat),
          style: textTheme.bodyText1.copyWith(letterSpacing: 3),
          textAlign: TextAlign.right,
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}

class SeeAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Text(
        'SEE ALL',
        style: textTheme.button,
      ),
    );
  }
}

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    Key key,
    @required this.budget,
  }) : super(key: key);

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: cardVPadding,
      child: LayoutGrid(
        columnSizes: [auto, 1.fr, auto],
        rowSizes: [
          auto,
          ...repeat(budget.categories.length, [auto]),
        ],
        children: [
          CardHeader(
            title: budget.name,
            leadingAmount: budget.totalSpentAmount.format(currencyFormat),
            leadingLabel: 'Left',
            trailingAmount: budget.totalAmount.format(currencyFormat),
            trailingLabel: 'Total',
          ).withGridPlacement(columnStart: 0, columnSpan: 3, rowStart: 0),

          // Categories
          for (int row = 1; row <= budget.categories.length; row++)
            ..._buildRowWidgets(row),
        ],
      ),
    );
  }

  List<Widget> _buildRowWidgets(int row) {
    final category = budget.categories[row - 1];

    return [
      TileLabelLockup(
        name: category.name,
        hint: '${category.spentAmount.format(currencyFormat)} / '
            '${category.totalAmount.format(currencyFormat)}',
      ).withGridPlacement(columnStart: 0, rowStart: row),
      BudgetCategoryProgress().withGridPlacement(columnStart: 1, rowStart: row),
      TileCurrency(
        amount: category.remainingAmount,
        trailing: Text('Left'),
      ).withGridPlacement(columnStart: 2, rowStart: row),
    ];
  }
}

class BudgetCategoryProgress extends StatelessWidget {
  const BudgetCategoryProgress({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.lightBlue, height: 4);
  }
}

class TileLabelLockup extends StatelessWidget {
  const TileLabelLockup({
    Key key,
    @required this.name,
    @required this.hint,
  }) : super(key: key);
  final String name;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: textTheme.subtitle1,
        ),
        SizedBox(height: 2),
        Text(
          hint,
          style: textTheme.caption.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            letterSpacing: 3,
            color: deemphasizedColor,
          ),
        ),
      ],
    );
  }
}

class CardHeader extends StatelessWidget {
  const CardHeader({
    Key key,
    this.title,
    this.leadingAmount,
    this.leadingLabel,
    this.trailingAmount,
    this.trailingLabel,
  }) : super(key: key);

  final String title;
  final String leadingAmount;
  final String leadingLabel;
  final String trailingAmount;
  final String trailingLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.subtitle2),
        SizedBox(height: 4),
        Row(
          children: [
            Text(leadingAmount, style: textTheme.headline3),
            if (leadingLabel != null)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  leadingLabel,
                  style: textTheme.bodyText2,
                  strutStyle: StrutStyle.fromTextStyle(textTheme.headline3),
                ),
              ),
            if (trailingAmount != null) ..._buildTrailingAmount(textTheme),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildTrailingAmount(TextTheme textTheme) {
    final trailingHeadlineStyle =
        textTheme.headline3.copyWith(color: deemphasizedColor);
    return [
      const SizedBox(width: 20),
      Text('/', style: trailingHeadlineStyle),
      const SizedBox(width: 20),
      Text(trailingAmount, style: trailingHeadlineStyle),
      if (trailingLabel != null)
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            trailingLabel,
            style: textTheme.bodyText2.copyWith(color: deemphasizedColor),
            strutStyle: StrutStyle.fromTextStyle(textTheme.headline3),
          ),
        ),
    ];
  }
}

class AlertsCard extends StatelessWidget {
  const AlertsCard({
    Key key,
    this.alerts,
    this.alertCount,
    this.axis,
  }) : super(key: key);

  final List<Alert> alerts;
  final int alertCount;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final alertsToShow =
        alertCount != null ? alerts.sublist(0, alertCount) : alerts;
    final alertsList = axis == Axis.vertical
        ? Column(
            children: [
              for (final alert in alertsToShow) ...[
                Container(
                  margin: cardHPadding,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: backgroundColor, width: 1.5),
                    ),
                  ),
                ),
                Padding(
                  padding: cardHPadding.copyWith(top: 14, bottom: 14),
                  child: AlertTile(alert: alert),
                ),
              ]
            ],
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple)
            ),
            child: LayoutGrid(
              gridFit: GridFit.loose,
              columnSizes: [1.fr, 1.fr, 1.fr],
              rowSizes: [auto],
              debugLabel: 'alerts',
              children: [
                for (final alert in alertsToShow) AlertTile(alert: alert),
              ],
            ),
          );

    return Container(
      color: cardColor,
      child: Column(
        children: [
          AlertHeader(),
          alertsList,
        ],
      ),
    );
  }
}

class AlertHeader extends StatelessWidget {
  const AlertHeader({
    Key key,
    this.drawTopBorder = true,
    this.includeSeeAll = false,
  }) : super(key: key);

  final bool drawTopBorder;
  final bool includeSeeAll;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: textColor, width: 8)),
      ),
      child: Padding(
        padding: cardHPadding.copyWith(top: 20, bottom: 20),
        child: Row(
          children: [
            Text(
              'Alerts',
              style: textTheme.subtitle2,
            ),
            if (includeSeeAll) SeeAllButton(),
          ],
        ),
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  const AlertTile({Key key, this.alert}) : super(key: key);
  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            alert.description,
            style: textTheme.subtitle1.copyWith(height: 1.4),
          ),
        ),
        SizedBox(width: 32),
        Icon(
          alert.icon,
          size: 22,
          color: iconColor,
        ),
      ],
    );
  }
}
