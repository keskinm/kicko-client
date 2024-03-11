import 'package:flutter/material.dart';

class OpenPDF extends StatefulWidget {
  final String jobOfferId;
  const OpenPDF({Key? key, required this.jobOfferId}) : super(key: key);

  @override
  _OpenPDFState createState() => _OpenPDFState();
}

class _OpenPDFState extends State<OpenPDF> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('This is a stub implementation and should not be visible.'),
      ),
    );
  }
}
