// import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/end_point.dart';
import 'package:kicko/services/firebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:kicko/services/app_state.dart';

Future selectFiles(int position) async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);

  if (result != null) {
    // List<File> files = result.paths.map((path) => File(path)).toList();
  } else {
    // User canceled the picker
  }
}

Future<Uint8List?> selectFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc'],
  );
  Uint8List? s;
  if (result != null) {
    s = result.files.single.bytes;
  } else {
    // User canceled the picker
  }
  return s;
}

class DisplayResumes extends StatefulWidget {
  final String bucket;
  const DisplayResumes({Key? key, required this.bucket}) : super(key: key);

  @override
  _DisplayResumes createState() => _DisplayResumes();
}

class _DisplayResumes extends State<DisplayResumes> {
  bool isBlockedResumes = false;
  late dynamic resumes;
  onReBuild() {
    resumes = Provider.of<FireBaseServiceInterface>(context, listen: false)
        .downloadFiles(widget.bucket);
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  Future<void> addResume() async {
    Uint8List? file = await selectFile();

    if (file == null) {
      throw Exception('an exception occured');
    } else {
      String postId = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = "post_$postId.pdf";
      await Provider.of<FireBaseServiceInterface>(context, listen: false)
          .uploadFile(widget.bucket, fileName, file);
    }
  }

  buildResumesWraps(dynamic storageReferences) {
    List<Widget> r = [];

    for (dynamic storageReference in storageReferences) {
      String storageReferenceBasename =
          storageReference.split('%2F').last.split('?')[0];

      Widget w = InkWell(
        onTap: () async {
          if (await canLaunch(storageReference)) {
            await launch(storageReference,
                forceSafariVC: false, forceWebView: false);
          } else {
            throw 'Could not launch $storageReference';
          }
        },
        child: !isBlockedResumes
            ? Column(
                children: [
                  const Icon(Icons.picture_as_pdf_rounded),
                  Text(storageReferenceBasename),
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          isBlockedResumes = true;
                          onReBuild();
                        });
                        Provider.of<FireBaseServiceInterface>(context,
                                listen: false)
                            .deleteFireBaseStorageItem(storageReference);
                        setState(() {
                          isBlockedResumes = false;
                          onReBuild();
                        });
                      },
                      icon: const Icon(Icons.delete))
                ],
              )
            : const CircularProgressIndicator(color: Colors.orange),
      );

      r.add(w);
    }

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(context),
      body: Column(
        children: [
          Center(
              child: ElevatedButton(
            onPressed: () async {
              setState(() {
                isBlockedResumes = true;
                onReBuild();
              });
              await addResume();
              setState(() {
                isBlockedResumes = false;
                onReBuild();
              });
            },
            child: Text(
              'Ajouter un CV',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          )),
          FutureBuilder(
            future: resumes,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                dynamic resumesList = snapshot.data;

                return !isBlockedResumes
                    ? Wrap(children: buildResumesWraps(resumesList))
                    : const CircularProgressIndicator(
                        color: Colors.orange,
                      );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator(
                    color: Colors.orangeAccent);
              }
            },
          ),
        ],
      ),
    );
  }
}

class DisplayProfileImages extends StatefulWidget {
  final String bucket;
  final String updateRoute;
  const DisplayProfileImages(
      {Key? key, required this.bucket, required this.updateRoute})
      : super(key: key);

  @override
  _DisplayProfileImages createState() => _DisplayProfileImages();
}

class _DisplayProfileImages extends State<DisplayProfileImages> {
  bool inProcess = false;
  late dynamic profileImages;

  onReBuild() {
    profileImages =
        Provider.of<FireBaseServiceInterface>(context, listen: false)
            .downloadFiles(widget.bucket);
  }

  buildImageProfileWraps(dynamic storageReferences) {
    List<Widget> r = [];

    for (dynamic storageReference in storageReferences) {
      String storageReferenceBasename =
          storageReference.split('%2F').last.split('?')[0];
      Widget w = Container(
        child: InkWell(
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextButton(
                            onPressed: () async {
                              await postRequest(
                                  widget.updateRoute,
                                  [appState.currentUser.id],
                                  {"image_id": storageReferenceBasename});
                              Navigator.of(context).pop();
                            },
                            child: Text("Définir comme image de profil",
                                style:
                                    Theme.of(context).textTheme.displaySmall)),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Retour",
                            style: Theme.of(context).textTheme.displaySmall),
                      ),
                    ],
                  );
                });
          }, // Image tapped
          splashColor: Colors.white10, // Splash color over image
          child: Image.network(
            storageReference,
            fit: BoxFit.fill,
          ),
        ),
        width: 200,
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      );

      r.add(w);
    }

    return r;
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  Future<XFile?> selectImageFromGallery() async {
    final picker = ImagePicker();

    setState(() {
      inProcess = true;
    });

    Future<XFile?> xFile = picker.pickImage(source: ImageSource.gallery);

    setState(() {
      inProcess = false;
    });

    return xFile;
  }

  Future<void> addProfileImage(String updateRoute) async {
    XFile? image = await selectImageFromGallery();

    if (image == null) {
      throw Exception('an exception occured');
    } else {
      String postId = DateTime.now().millisecondsSinceEpoch.toString();
      String imageName = "post_$postId.jpg";
      await Provider.of<FireBaseServiceInterface>(context, listen: false)
          .uploadFile(widget.bucket, imageName, image.readAsBytes());
      Map res = await postRequest(updateRoute,
          [appState.currentUser.id], {"image_id": imageName});
      if (res.containsKey("success") && res["success"]) {
        setState(() {});
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Images de profil"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
              child: ElevatedButton(
            onPressed: () async {
              await addProfileImage(widget.updateRoute);
              setState(() {
                onReBuild();
              });
            },
            child: Text(
              'Ajouter photo de profile',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          )),
          FutureBuilder(
            future: profileImages,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                dynamic profileImagesList = snapshot.data;

                return Wrap(
                    children: buildImageProfileWraps(profileImagesList));
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
