import 'dart:convert';
import 'package:kicko/appbar.dart';
import 'package:flutter/material.dart';
import 'package:kicko/end_point.dart';
import 'dart:html' as html;

import '../../services/app_state.dart';

void openPdf(String base64Pdf) {
  final contentType = 'application/pdf';
  final blob = html.Blob([base64.decode(base64Pdf)], contentType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  html.Url.revokeObjectUrl(url);
}

class OpenPDF extends StatefulWidget {
  final String jobOfferId;
  const OpenPDF({Key? key, required this.jobOfferId}) : super(key: key);

  @override
  _DisplayPDFState createState() => _DisplayPDFState();
}

class _DisplayPDFState extends State<OpenPDF> {
  late Future<String> _pdfFilePath;

  Future<String> getPdfFilePath() async {
    String data = await getRequest("professional_get_job_offer",
        [appState.currentUser.username, widget.jobOfferId]);
    Map pdfData = json.decode(data);
    return pdfData["res"].toString();
  }

  @override
  void initState() {
    setState(() {
      _pdfFilePath = getPdfFilePath();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(context),
      body: FutureBuilder<String>(
        future: _pdfFilePath,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            openPdf(snapshot.data!);
            return Center(child: Text("Le pdf s'est ouvert dans un nouvel onglet."));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
