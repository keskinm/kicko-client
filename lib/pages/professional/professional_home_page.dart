import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/pages/professional/professional_home_style.dart';
import 'package:kicko/pages/professional/qr_code_image.dart';

import 'package:kicko/syntax.dart';
import 'package:kicko/services/app_state.dart';
import '../common.dart';
import 'job_offer_page.dart';
import 'package:kicko/pages/medias.dart';

class ProHome extends StatefulWidget {
  const ProHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProHome();
  }
}

class _ProHome extends State<ProHome> {
  ProfessionalHomeLogic logic = ProfessionalHomeLogic();
  ProfessionalHomeStyle style = ProfessionalHomeStyle();
  late Future<Map<String, dynamic>> business;
  late Future<String> imageDownloadURL;
  late Future<List<dynamic>> jobOffers;
  String imagesBucket =
      '${userGroupSyntax.professional}/${appState.currentUser.username}/business_images';

  onReBuild() {
    business = logic.getBusiness();
    imageDownloadURL = logic.getProfileImage(business, imagesBucket);
    jobOffers = logic.getJobOffers();
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  Container buildContainerWithText(String text) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.purple),
              top: BorderSide(color: Colors.purple))),
      child: Text(text),
    );
  }

  Widget buildBusiness() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([business, imageDownloadURL]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          logic.businessJson["id"] = snapshot.data![0]["id"];
          List<Widget> regularFields = [];
          List<String> fields = ["name"];
          for (final String field in fields) {
            // regularFields.add(value);
          }

          String cityInitialValue = '';
          String nameInitialValue = '';

          if (snapshot.data![0].containsKey("city")) {
            cityInitialValue = snapshot.data![0]["city"];
          }

          selectionCallback(String selection) {
            logic.nonNullable(
                value: selection, key: "city", jsonModel: logic.businessJson);
          }

          Widget cityChild = CityAutocompletion(
              initialValue: cityInitialValue,
              selectionCallback: selectionCallback);

          if (snapshot.data![0].containsKey("name")) {
            nameInitialValue = snapshot.data![0]["name"];
          }

          Widget nameChild = Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.purple),
                    top: BorderSide(color: Colors.purple))),
            child: TextFormField(
              initialValue: nameInitialValue,
              validator: (value) => logic.nonNullable(
                  value: value, key: "name", jsonModel: logic.businessJson),
              decoration:
                  style.inputDecoration(hintText: 'Nom de votre entreprise'),
            ),
          );

          MaterialButton endChild = MaterialButton(
            onPressed: () => logic.validateBusiness(context: context),
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.red])),
              child: const Center(
                child: Text(
                  'Enregistrer les modifications',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );

          Widget businessAvatar = Stack(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey.shade200,
                child: CircleAvatar(
                  radius: 70,
                  child: ClipOval(
                    child: Image.network(
                      snapshot.data![1],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DisplayProfileImages(bucket: imagesBucket)),
                      ).then((_) {
                        setState(() {
                          onReBuild();
                        });
                      });
                    },
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Colors.white,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(2, 4),
                          color: Colors.black.withOpacity(
                            0.3,
                          ),
                          blurRadius: 3,
                        ),
                      ]),
                ),
              ),
            ],
          );

          return SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(), // Use this to enable scrolling only when needed
            child: Center(
              // Center the content horizontally
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 8.0), // Add some vertical padding
                width: MediaQuery.of(context).size.width >
                        600 // Set a max width for larger screens
                    ? 600 // Max form width
                    : MediaQuery.of(context)
                        .size
                        .width, // Full width for smaller screens
                child: Form(
                  key: logic.businessForm,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      businessAvatar,
                      nameChild,
                      cityChild,
                      endChild,
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          body = Text('Error: ${snapshot.error}');
        } else {
          body = const CircularProgressIndicator(
            color: Colors.orangeAccent,
          );
        }
        return Scaffold(body: body);
      },
    );
  }

  Widget buildJobOffers() {
    return FutureBuilder<List<dynamic>>(
      future: jobOffers,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            body = const Center(
                child: Text("Vous n'avez ajouté aucune offre d'emploi."));
          } else {
            body = ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final jobOffer = snapshot.data![index];
                String jobOfferId = jobOffer["id"];
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Colors.amber[600],
                      child: Text(jobOffer['name']),
                    ),
                    Container(
                      height: 50,
                      color: Colors.amber[500],
                      child: Text(jobOffer['description']),
                    ),
                    Container(
                      height: 50,
                      color: Colors.amber[100],
                      child: Text(jobOffer['requires']),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DisplayQRCodeImage(jobOfferId: jobOfferId)),
                          );
                        },
                        child: const Text("J'inprime mon QR code")),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        bool success = await logic.deleteJobOffer(jobOfferId);

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProHome()),
                          );
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return buildPopupDialog(
                                    context,
                                    "Nous avons rencontré un problème lors de la suppression de votre offre d'emploi.",
                                    "oups",
                                    "fermer");
                              });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.panorama_fish_eye),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfessionalJobOfferPage(
                                  jobOfferId: jobOfferId)),
                        );
                      },
                    )
                  ],
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          body = Text('Error: ${snapshot.error}');
        } else {
          body = const CircularProgressIndicator(
            color: Colors.orange,
          );
        }
        return Scaffold(body: body);
      },
    );
  }

  Widget buildAddJobOffer(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: logic.jobOfferForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) => logic.nonNullable(
                      value: value, key: "name", jsonModel: logic.jobOfferJson),
                  decoration: style.inputDecoration(
                      hintText: 'Nom de l\'offre d\'emploi'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) => logic.nonNullable(
                      value: value,
                      key: "description",
                      jsonModel: logic.jobOfferJson),
                  decoration: style.inputDecoration(hintText: 'Description'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) => logic.nonNullable(
                      value: value,
                      key: "requires",
                      jsonModel: logic.jobOfferJson),
                  decoration: style.inputDecoration(
                      hintText: 'Compétences ou points imports requis'),
                ),
              ),
              MaterialButton(
                onPressed: () => logic.validateJobOffer(context: context),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.red])),
                  child: const Center(
                    child: Text(
                      'Valider',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: menuAppBar("Bienvenu dans votre tableau de bord !", context),
        body: Center(
            child: Column(
          children: [
            Expanded(
              child: buildBusiness(),
            ),
            Expanded(
              child: Wrap(
                spacing: 100,
                children: [buildJobOffers(), buildAddJobOffer(context)]
                    .map((child) => SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 4,
                          child: child,
                        ))
                    .toList(),
              ),
            ),
          ],
        )));
  }
}
