// Colors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money2/money2.dart';

const backgroundColor = Color(0xff33333c);
const textColor = Color(0xffe6e6e8);
final deemphasizedColor = textColor.withOpacity(0.45);
const cardColor = Color(0xff37373f);
const cardTopperColor = Color(0xfffbfeff);
const iconColor = Color(0xffb0b0b3);

enum InfoColorTheme {
  green,
  orange,
  purple,
}

final infoColorsByTheme = {
  InfoColorTheme.green: [
    Color(0xff075d56),
    Colors.green[700],
    Colors.green[500],
    Colors.green[300],
  ],
  InfoColorTheme.orange: [
    Color(0xfffedc78),
    Color(0xfffd6858),
    Color(0xfffed7cf),
    Color(0xfffead12),
  ],
  InfoColorTheme.purple: [
    Color(0xff1382fb),
    Color(0xffb15cff),
    Color(0xffa932ff),
    Color(0xffb2f2ff),
  ],
};

// Typography

final eczar = GoogleFonts.eczar(
  color: textColor,
  fontFeatures: [FontFeature.tabularFigures()],
);
final robotoCondensed = GoogleFonts.robotoCondensed(color: textColor);

final rallyTextTheme = TextTheme(
  headline1: robotoCondensed.copyWith(
    fontSize: 96,
    fontWeight: FontWeight.w300,
  ),
  headline2: robotoCondensed.copyWith(
    fontSize: 60,
    fontWeight: FontWeight.w300,
  ),
  headline3: eczar.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    height: 1.5,
  ),
  headline4: robotoCondensed.copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w400,
  ),
  headline5: robotoCondensed.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  headline6: robotoCondensed.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  subtitle1: robotoCondensed.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  subtitle2: robotoCondensed.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  bodyText1: eczar.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyText2: robotoCondensed.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  ),
  caption: robotoCondensed.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  button: robotoCondensed.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  ),
);

// Spacing

final cardVPadding = EdgeInsets.only(top: 18);
final cardHPadding = EdgeInsets.symmetric(horizontal: 14);

// Currency formatting

final displayCurrency = CommonCurrencies().usd;
final currencyFormat = 'S###,###.##';
