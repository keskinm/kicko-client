// import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kicko/services/app_state.dart';


Future<String> getProfileImage() async {
  String bucket;

  dynamic jsonResp = await ProfessionalHomeLogic().getBusiness();
  String? profileImageId = jsonResp['image_id'];

  if (profileImageId == null) {
    bucket = 'profile_images';
    profileImageId = 'ca_default_profile.jpg';
  } else {
    String currentUsername = appState.currentUser.username;
    bucket = 'profile_images/$currentUsername';
  }

  return DatabaseMethods().downloadFile(bucket, profileImageId);
}

class LoadFirebaseStorageImage extends StatefulWidget {
  const LoadFirebaseStorageImage({Key? key}) : super(key: key);

  @override
  _LoadFirebaseStorageImageState createState() =>
      _LoadFirebaseStorageImageState();
}

class _LoadFirebaseStorageImageState extends State<LoadFirebaseStorageImage> {
  bool inProcess = false;
  DatabaseMethods dataBaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<String>(
          future: getProfileImage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic im = snapshot.data;
              return Container(
                child: Column(
                  children: [
                    Container(
                      child: kIsWeb
                          ? Image.network(
                        im,
                        fit: BoxFit.fill,
                      )
                          : Image.file(
                        File(im),
                        fit: BoxFit.fill,
                      ),
                      width: 200,
                      height: 200,
                    ),
                    ElevatedButton(
                      onPressed: () => addProfileImage(),
                      child: const Text('Ajouter photo de profile'),
                    ),
                    ElevatedButton(
                      child: const Text('Changer photo de profile'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DisplayProfileImages()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Text('Chargement...');
            }
          })
    ]);
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
          'profile_images/$currentUsername', imageName, image);
      bool res = await dataBaseMethods.updateTableField(imageName, "image_id", "update_business_fields");
      if (res) {
        print("popup succesfully uploaded");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoadFirebaseStorageImage()),
        );
      }
      else {

      }
    }
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
}




class DisplayProfileImages extends StatefulWidget {
  const DisplayProfileImages({Key? key}) : super(key: key);

  @override
  _DisplayProfileImages createState() =>
      _DisplayProfileImages();

}

class _DisplayProfileImages extends State<DisplayProfileImages>{
  bool inProcess = false;
  late dynamic profileImages;
  DatabaseMethods dataBaseMethods = DatabaseMethods();


  buildImageProfileWraps(dynamic storageReferences) {
    List<Widget> r = [];

    for (dynamic storageReference in storageReferences) {
      String storageReferenceBasename = storageReference.split('%2F').last.split('?')[0];
      Widget w = Column(

        children: [

          Container(
            child: Image.network(storageReference, fit: BoxFit.fill,),
            width: 200,
            height: 200,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          ),

          ElevatedButton(
              onPressed: () => dataBaseMethods.updateTableField(storageReferenceBasename, "image_id", "update_business_fields"),
              child: Text('X')
          )

        ],

      );

      r.add(w);

    }

    return r;
  }



  getProfileImages() async {
    String currentUsername = appState.currentUser.username;
    String bucket = 'profile_images/$currentUsername';
    return dataBaseMethods.downloadFiles(bucket);
  }


  @override
  void initState() {
    super.initState();
    profileImages = getProfileImages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Images"),
      ),
      body: Column(children: [


        FutureBuilder(
          future: profileImages,
          builder: (context, AsyncSnapshot snapshot) {

            if (snapshot.hasData) {

              dynamic profileImagesList = snapshot.data;

              return Column(children: buildImageProfileWraps(profileImagesList)
              );

            }

            else {
              return const Text('Chargement..');
            }

          },
        ),


        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);},
          child: const Text('Go back!'),
        ),


      ],
      ),
    );
  }
}

