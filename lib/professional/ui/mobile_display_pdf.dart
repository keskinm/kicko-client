import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:kicko/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kicko/end_point.dart';

import '../../services/app_state.dart';

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
    Uint8List bytes = base64Decode(pdfData["res"].toString());
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/job_offer.pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  void initState() {
    super.initState();
    _pdfFilePath = getPdfFilePath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(context),
      body: FutureBuilder<String>(
        future: _pdfFilePath,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PDFView(
              filePath: snapshot.data,
            );
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
