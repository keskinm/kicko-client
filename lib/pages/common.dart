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


Widget devPage(BuildContext context, Widget page) {
  return TextButton(onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    );
  }, child: const Text("go to devpage"));
}
