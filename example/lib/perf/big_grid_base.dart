import 'package:flutter/material.dart';

abstract class BigGridBase extends StatelessWidget {
  const BigGridBase({Key key, this.title, this.gridKey}) : super(key: key);
  final String title;
  final GlobalKey gridKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xff202020),
            fontSize: 16,
          ),
        ),
        Container(
          color: Colors.grey[400],
          child: buildGrid(gridKey),
        ),
      ],
    );
  }

  Widget buildGrid(GlobalKey gridKey);
}
