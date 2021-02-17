import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money2/money2.dart';

import 'theme.dart';

// Demo data

final demoAccounts = AccountCategory(
  'Accounts',
  accounts: [
    Account('Checking', amount: r'$2215.13', hint: '••••••1234'),
    Account('Home Savings', amount: r'$8676.88', hint: '••••••5678'),
    Account('Car Savings', amount: r'$987.48', hint: '••••••9012'),
    Account('Vacation', amount: r'$253.00', hint: '••••••3456'),
  ],
  colorTheme: InfoColorTheme.green,
);

final demoBills = AccountCategory(
  'Bills',
  accounts: [
    Account('RedPay Credit', amount: r'$-45.63', hint: 'Due Jan 28'),
    Account('Rent', amount: r'$-1200.00', hint: 'Due Feb 9'),
    Account('TabFine Credit', amount: r'$-87.33', hint: 'Due Feb 22'),
    Account('ABC Loans', amount: r'$-400.00', hint: 'Due Feb 29'),
  ],
  colorTheme: InfoColorTheme.orange,
);

final demoBudget = Budget('January Budget', categories: [
  BudgetCategory('Coffee Shops',
      spentAmount: r'$49.49', totalAmount: r'$70.00'),
  BudgetCategory('Groceries', spentAmount: r'$16.45', totalAmount: r'$170.00'),
  BudgetCategory('Restaurants',
      spentAmount: r'$123.25', totalAmount: r'$170.00'),
]);

final demoAlerts = [
  Alert('Heads up, youʼve used up 90% of your Shopping budget for this month.',
      Icons.sort),
  Alert(r'Youʼve spent $120 on Restaurants this week.', Icons.sort),
  Alert(
      r'Youʼve spent $24 in ATM fees this month.', Icons.credit_card_outlined),
  Alert(r'Good work! Your checking account is 4% than this time last month.',
      Icons.attach_money),
  Alert(
      r'Increase your potential tax deductions! Assign categories to 16 unassigned transactions.',
      Icons.not_interested),
  Alert(
      r'Get every tax deduction youʼre entitled to. Assign categories to 16 unassigned transactions.',
      Icons.pie_chart_outlined),
  Alert(r'Your ABC Loan payment of $325.81 was received!', Icons.attach_money),
  Alert(r'Open an IRA account and get a $100 bonus.', Icons.attach_money),
];

class AccountCategory {
  AccountCategory(
    this.name, {
    @required this.accounts,
    @required this.colorTheme,
  });

  final String name;
  final InfoColorTheme colorTheme;
  final List<Account> accounts;

  Color colorAtIndex(int index) {
    final themeColors = infoColorsByTheme[colorTheme];
    return themeColors[index % infoColorsByTheme[colorTheme].length];
  }

  Money get totalAmount =>
      accounts.fold(Money.from(0, displayCurrency), (acc, a) => acc + a.amount);

  Money get absTotalAmount {
    final amount = totalAmount;
    return amount.isNegative ? -amount : amount;
  }
}

class Account {
  Account(
    this.name, {
    String amount,
    this.hint,
  }) : this.amount = displayCurrency.parse(amount);

  final String name;
  final String hint;
  final Money amount;
}

class Budget {
  Budget(this.name, {this.categories});

  final String name;
  final List<BudgetCategory> categories;

  Money get totalSpentAmount {
    return categories.fold(
        Money.fromInt(0, displayCurrency), (acc, b) => acc + b.spentAmount);
  }

  Money get totalRemainingAmount {
    return totalAmount - totalSpentAmount;
  }

  Money get totalAmount {
    return categories.fold(
        Money.fromInt(0, displayCurrency), (acc, b) => acc + b.totalAmount);
  }
}

class BudgetCategory {
  BudgetCategory(
    this.name, {
    String spentAmount,
    String totalAmount,
  })  : this.spentAmount = Money.parse(spentAmount, displayCurrency),
        this.totalAmount = Money.parse(totalAmount, displayCurrency);

  final String name;
  final Money spentAmount;
  final Money totalAmount;
  Money get remainingAmount => totalAmount - spentAmount;
}

class Alert {
  Alert(this.description, this.icon);
  final String description;
  final IconData icon;

  String toString() => 'Alert($description)';
}
