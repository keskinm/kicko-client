import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/end_point.dart';
import 'package:kicko/services/firebase.dart';

import '../../services/app_state.dart';
import '../../syntax.dart';
import 'package:provider/provider.dart';

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
  late Future<Map> getPdf;

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
    return Provider.of<FireBaseServiceInterface>(context, listen: false)
        .downloadFile(bucket, widget.jobOfferId);
  }

  onRebuild() {
    getPdf = getRequest("professional_get_job_offer", [appState.currentUser.username, widget.jobOfferId]);
  }

  @override
  void initState() {
    super.initState();
    qrCodeImage = getQrCodeImage();
    onRebuild();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: simpleAppBar(context),
        body: Center(
          child: Column(
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
        ));
  }
}
