import 'package:flutter/material.dart';

AppBar protoAppBar(String text) {
  return AppBar(
    // backgroundColor: Colors.deepOrangeAccent,
    // No need backgroundColor because done in ThemData of MaterialApp.
    title: Center(child: Text(text)),
  );
}
