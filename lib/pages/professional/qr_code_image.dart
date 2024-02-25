import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/services/database.dart';

import '../../services/app_state.dart';
import '../../syntax.dart';

class DisplayQRCodeImage extends StatefulWidget {
  final String jobOfferId;
  const DisplayQRCodeImage({Key? key, required this.jobOfferId})
      : super(key: key);

  @override
  _DisplayQRCodeImage createState() => _DisplayQRCodeImage();
}

class _DisplayQRCodeImage extends State<DisplayQRCodeImage> {
  bool inProcess = false;
  late dynamic qrCodeImage;
  FireBaseService dataBaseMethods = FireBaseService();

  buildQrCodeDisplay(dynamic storageReference) {
    return Container(
      child: Image.network(
        storageReference,
        fit: BoxFit.fill,
      ),
      width: 200,
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }

  getQrCodeImage() async {
    String bucket =
        '${userGroupSyntax.professional}/${appState.currentUser.username}/job_offer_qr_codes';
    return dataBaseMethods.downloadFile(bucket, widget.jobOfferId);
  }

  @override
  void initState() {
    super.initState();
    qrCodeImage = getQrCodeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: protoAppBar("Image de profil"),
      body: Column(
        children: [
          FutureBuilder(
            future: qrCodeImage,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                dynamic qrCodeImageRef = snapshot.data;

                return buildQrCodeDisplay(qrCodeImageRef);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator(
                  color: Colors.orangeAccent,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
