import 'package:flutter/material.dart';

import './piet_painting.dart';

void main() {
  runApp(PietApp());
}

class PietApp extends StatelessWidget {
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
