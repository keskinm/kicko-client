import 'package:flutter/material.dart';

Widget blockLine(String text, Color bgColor, Color textColor) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      color: bgColor,
      border: Border.all(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(5.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      text,
      style: TextStyle(color: textColor),
    ),
  );
}

List<Widget> block(List<String> texts) {
  List<Color> colors = [
    Color.fromARGB(255, 241, 249, 5),
    Color.fromARGB(255, 2, 6, 12),
  ];
  List<Widget> blocks = [];
  for (int i = 0; i < texts.length; i++) {
    blocks.add(blockLine(
        texts[i], colors[i % colors.length], colors[(i + 1) % colors.length]));
  }
  return blocks;
}
