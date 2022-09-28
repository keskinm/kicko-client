// import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kicko/services/app_state.dart';


class DisplayProfileImages extends StatefulWidget {
  const DisplayProfileImages({Key? key}) : super(key: key);

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
      Widget w = Column(
        children: [
          Container(
            child: Image.network(
              storageReference,
              fit: BoxFit.fill,
            ),
            width: 200,
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          ),
          ElevatedButton(
              onPressed: () => dataBaseMethods.updateTableField(
                  storageReferenceBasename,
                  "image_id",
                  "update_business_fields"),
              child: Text('X'))
        ],
      );

      r.add(w);
    }

    return r;
  }

  getProfileImages() async {
    String currentUsername = appState.currentUser.username;
    String bucket = 'business_images/$currentUsername';
    return dataBaseMethods.downloadFiles(bucket);
  }

  @override
  void initState() {
    super.initState();
    profileImages = getProfileImages();
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
      String currentUsername = appState.currentUser.username;
      await dataBaseMethods.uploadFile(
          'business_images/$currentUsername', imageName, image);
      bool res = await dataBaseMethods.updateTableField(
          imageName, "image_id", "update_business_fields");
      if (res) {
        print("popup succesfully uploaded");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DisplayProfileImages()),
        );
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: protoAppBar("Images de profil"),
      body: Column(
        children: [
          FutureBuilder(
            future: profileImages,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                dynamic profileImagesList = snapshot.data;

                return Column(
                    children: buildImageProfileWraps(profileImagesList));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Chargement...');
              }
            },
          ),
          ElevatedButton(
            onPressed: () => addProfileImage(),
            child: const Text('Ajouter photo de profile'),
          ),

        ],
      ),
    );
  }
}
