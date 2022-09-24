import 'package:flutter/material.dart';
import 'package:kicko/pages/candidate/scan.dart';

import 'package:kicko/pages/common.dart';
import 'package:kicko/syntax.dart';
import 'candidate_home_logic.dart';
import 'candidate_home_style.dart';
import 'job_offer_page.dart';

class CandidateHome extends StatefulWidget {
  const CandidateHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CandidateHome();
  }
}

class _CandidateHome extends State<CandidateHome> {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  Map<String, dynamic> profileJson = {};
  CandidateHomeLogic logic = CandidateHomeLogic();
  CandidateHomeStyle style = CandidateHomeStyle();
  late Future<Map> profile;
  late Future<List> jobOffers;

  onReBuild() {
    profile = logic.getProfile();
    jobOffers = logic.getJobOffers(jobOfferFilters);
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
  }


  Widget buildDropDown(String key, List<dynamic> list, int dropdownValueIdx) {
    String dropdownValue = list[dropdownValueIdx];
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
        profileJson["l_"+key] = value;
        profileJson[key] = list.indexOf(value!);

        //@todo est-ce une bonne idée ?
        setState(() {
          dropdownValue = value;
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
    return FutureBuilder<Map>(
        future: profile,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          Widget body;
          if (snapshot.hasData) {
            body = Column(
              children: [
                buildDropDown("sex", snapshot.data!["syntax"]["sex"], snapshot.data!["instance"]["sex"]),
                buildDropDown("study_level", snapshot.data!["syntax"]["study_level"], snapshot.data!["instance"]["study_level"])
              ],
            );
          } else if (snapshot.hasError) {
            body = Text('Error: ${snapshot.error}');
          } else {
            body = const Text('Chargement...');
          }

          return Scaffold(body: body);
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

          Widget cityFilter = CityAutocompletion(
              initialValue: '', selectionCallback: selectionCallback);
          Widget validateCityFilter = IconButton(
            onPressed: () {
              setState(() {
                onReBuild();
              });
            },
            icon: const Icon(Icons.check_box),
          );
          Widget cityChild = Wrap(children: [cityFilter, validateCityFilter]);

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
          body = Text('Error: ${snapshot.error}');
        } else {
          body = const Text('Awaiting result...');
        }
        return Scaffold(body: body);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenu dans votre tableau de bord !'),
        ),
        body: Wrap(
          spacing: 100,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 4,
                child: buildProfile()),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 4,
                child: buildJobOffers()),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanScreen()),
                  );
                },
                child: const Text('SCAN QR CODE'))
          ],
        ));
  }
}
