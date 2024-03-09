import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/candidate/ui/scan.dart';

import 'package:kicko/shared/common.dart';
import 'package:kicko/syntax.dart';
import 'package:kicko/user/ui/medias.dart';
import 'package:kicko/chat/widget.dart';
import '../domain/candidate_home_logic.dart';
import '../../styles/candidate_home_style.dart';
import 'job_offer_page.dart';
import 'package:kicko/user/ui/user.dart';
import 'package:kicko/end_point.dart';
import 'package:kicko/services/app_state.dart';

class CandidateHome extends StatefulWidget {
  const CandidateHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CandidateHome();
  }
}

class _CandidateHome extends State<CandidateHome> with UserStateMixin {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  Map<String, dynamic> profileJson = {};
  Map<String, dynamic> profileJsonDropDown = {};

  CandidateHomeLogic logic = CandidateHomeLogic();
  CandidateHomeStyle style = CandidateHomeStyle();
  late Future<Map> profile;
  late Future<List> jobOffers;
  late Future<Map> profileChoices;

  String get resumesBucket => "${userGroupSyntax.candidate}/$userName/resumes";

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  onReBuild() {
    setState(() {
      profile = getRequest<Map<String, dynamic>>(
          "candidate_get_profile", [appState.currentUser.id]);
      jobOffers = postRequest("candidate_get_job_offers", [],
          logic.formatJobOfferFilters(jobOfferFilters));
    });
    profileChoices = getRequest("get_candidate_syntax", []);
    super.onRebuild();
  }

  Widget buildDropDown(String key, List<dynamic> list, String dropdownValue) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          profileJson[key] = value;
          profileJsonDropDown[key] = value;
        });
      },
      items: list.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildProfile() {
    return FutureBuilder<List>(
        future: Future.wait([profile, profileChoices]),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          Widget body;
          if (snapshot.hasData) {
            Map _profile = snapshot.data![0];
            Map _profileChoices = snapshot.data![1];

            List<Widget> dropDownButtons = [];

            for (String key in _profileChoices.keys) {
              if (profileJsonDropDown.containsKey(key)) {
                profileJson[key] = profileJsonDropDown[key];
              } else {
                profileJson[key] = _profile[key];
              }
              dropDownButtons.add(
                buildDropDown(key, _profileChoices[key], profileJson[key]),
              );
            }
            body = Column(
              children: dropDownButtons +
                  [
                    TextButton(
                        key: Key("save_profile_button"),
                        onPressed: () async {
                          try {
                            Map success = await postRequest(
                                "candidate_update_profile",
                                [appState.currentUser.id],
                                profileJson);
                            if (!success.isEmpty) {
                              setState(() {
                                showAlert(
                                    context,
                                    "Votre profile a été mise à jour avec succès!",
                                    "Bonne nouvelle",
                                    "fermer");
                                // profileJsonDropDown = {};
                                // onReBuild();
                              });
                            } else {
                              showAlert(
                                  context,
                                  "un problème est survenu du côté du serveur",
                                  "oups",
                                  "fermer");
                            }
                          } catch (err) {
                            showAlert(context, "$err", "oups", "fermer");
                          }
                        },
                        child: const Text("Sauvegarder"))
                  ],
            );
          } else if (snapshot.hasError) {
            body = Text('buildProfile Error: ${snapshot.error}');
          } else {
            body = const CircularProgressIndicator(
              color: Colors.orangeAccent,
            );
          }

          return body;
        });
  }

  Widget buildJobOffers() {
    return FutureBuilder<List<dynamic>>(
      future: jobOffers,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          selectionCallback(String selection) {
            jobOfferFilters["city"] = selection;
          }

          Widget cityFilter =
              CityAutocompletion(selectionCallback: selectionCallback);
          Widget validateCityFilter = IconButton(
            onPressed: () {
              onReBuild();
            },
            icon: const Icon(Icons.check_box),
          );
          Widget cityChild =
              Expanded(child: Wrap(children: [cityFilter, validateCityFilter]));

          if (snapshot.data!.isEmpty) {
            body = Column(children: [
              cityChild,
              const Text(
                  "Aucune offre d'emploi ne correspond à vos critères de recherches.")
            ]);
          } else if (snapshot.data![0].containsKey("error")) {
            body = const Text('Error');

            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return buildPopupDialog(
                      context,
                      "Un problème est survenu dans votre filtre par villes",
                      "Oups!",
                      "Fermer");
                });
          } else {
            ListView listView = ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final jobOffer = snapshot.data![index];
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
                    IconButton(
                      // APPLYING TO THE JOB
                      icon: const Icon(Icons.panorama_fish_eye_sharp),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateJobOfferPage(
                                  jobOfferId: jobOffer["id"]),
                            ));
                      },
                    )
                  ],
                );
              },
            );
            body = Column(children: [cityChild, Expanded(child: listView)]);
          }
        } else if (snapshot.hasError) {
          body = Text('buildJobOffers Error: ${snapshot.error}');
        } else {
          body = const Text('Awaiting result...');
        }
        return Scaffold(body: body);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 4,
          child: buildProfile()),
      TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayResumes(bucket: resumesBucket)),
            );
          },
          child:
              Text("Mes CV", style: Theme.of(context).textTheme.displayMedium)),
      SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 4,
          child: buildJobOffers()),
    ];

    if (!kIsWeb) {
      children.add(ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanScreen()),
            );
          },
          child: Text(
            'SCANNER UN QR CODE',
            style: Theme.of(context).textTheme.displayMedium,
          )));
    }

    children.addAll(chatWidgetsList(context, messagesNotification, this));

    return Scaffold(
        appBar: userAppBar("Bienvenu dans votre tableau de bord !", context),
        body: Center(
            child: Column(
          children: children,
        )));
  }
}
