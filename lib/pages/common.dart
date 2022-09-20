import 'package:flutter/material.dart';

Widget buildPopupDialog(BuildContext context, String message, String title, String close) {
  return AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(message),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(close),
      ),
    ],
  );
}
