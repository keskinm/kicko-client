// import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
  DatabaseMethods dataBaseMethods = DatabaseMethods();

  onReBuild() {
    resumes = dataBaseMethods.downloadFiles(widget.bucket);
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
      await dataBaseMethods.uploadFile(widget.bucket, fileName, file);
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
        child: !isBlockedResumes ? Column(
          children: [
            const Icon(Icons.picture_as_pdf_rounded),
            Text(storageReferenceBasename),
            IconButton(onPressed: () async {
              setState(() {
                isBlockedResumes = true;
                onReBuild();
              });
              dataBaseMethods.deleteFireBaseStorageItem(storageReference);
              setState(() {
                isBlockedResumes = false;
                onReBuild();
              });

            }, icon: const Icon(Icons.delete))
          ],
        ) : const CircularProgressIndicator(color: Colors.orange),
      );

      r.add(w);
    }

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: protoAppBar("Mes CV"),
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

                return !isBlockedResumes ? Wrap(children: buildResumesWraps(resumesList)) : const CircularProgressIndicator(color: Colors.orange,);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator(color: Colors.orangeAccent);
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
  const DisplayProfileImages({Key? key, required this.bucket})
      : super(key: key);

  @override
  _DisplayProfileImages createState() => _DisplayProfileImages();
}

class _DisplayProfileImages extends State<DisplayProfileImages> {
  bool inProcess = false;
  late dynamic profileImages;
  DatabaseMethods dataBaseMethods = DatabaseMethods();

  buildImageProfileWraps(dynamic storageReferences) {
    List<Widget> r = [];

    for (dynamic storageReference in storageReferences) {
      String storageReferenceBasename =
          storageReference.split('%2F').last.split('?')[0];
      Widget w = Container(
        child: InkWell(
          onTap: () {
            dataBaseMethods.updateTableField(
                storageReferenceBasename, "image_id", "update_business_fields");
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

  onReBuild() {
    profileImages = dataBaseMethods.downloadFiles(widget.bucket);
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

  Future<void> addProfileImage() async {
    XFile? image = await selectImageFromGallery();

    if (image == null) {
      throw Exception('an exception occured');
    } else {
      String postId = DateTime.now().millisecondsSinceEpoch.toString();
      String imageName = "post_$postId.jpg";
      await dataBaseMethods.uploadFile(
          widget.bucket, imageName, image.readAsBytes());
      bool res = await dataBaseMethods.updateTableField(
          imageName, "image_id", "update_business_fields");
      if (res) {
        setState(() {});
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: protoAppBar("Images de profil"),
      body: Column(
        children: [
          Center(
              child: ElevatedButton(
            onPressed: () async {
              await addProfileImage();
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
                return const Text('Chargement...');
              }
            },
          ),
        ],
      ),
    );
  }
}
