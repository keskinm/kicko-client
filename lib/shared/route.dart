import 'package:flutter/material.dart';

pushSetStateWhenBack(
    BuildContext context, dynamic builder, Function setStates) {
  Navigator.push(context, MaterialPageRoute(builder: builder)).then((_) {
    setStates();
  });
}
