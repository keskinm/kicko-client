import 'package:flutter/material.dart';

import 'package:kicko/pages/common.dart';
import 'package:kicko/syntax.dart';
import 'candidate_home_logic.dart';
import 'candidate_home_style.dart';

class CandidateJobOfferPage extends StatefulWidget {
  final String jobOfferId;
  const CandidateJobOfferPage({Key? key, required this.jobOfferId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CandidateJobOfferPage();
  }
}

class _CandidateJobOfferPage extends State<CandidateJobOfferPage> {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  CandidateHomeLogic logic = CandidateHomeLogic();
  CandidateHomeStyle style = CandidateHomeStyle();
  late Future<Map> jobOffer;
  late Future<bool> appliedJobOffer;

  onReBuild() {}

  @override
  void initState() {
    super.initState();
    jobOffer = logic.getJobOffer(jobOfferId: widget.jobOfferId);
    appliedJobOffer = logic.appliedJobOffer(jobOfferId: widget.jobOfferId);
  }

  Widget buildJobOffer() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([jobOffer, appliedJobOffer]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          Map _jobOffer = snapshot.data![0];

          // SINGLE ELEMENT LIST
          bool _applyJobOffer = snapshot.data![1];

          if (_jobOffer.containsKey("error") | false) {
            // C'est là qu'il faut apprendre à catch les erreurs correctement !
            // Le false doit être remplacé par le fait ou non que appliedJobOffer renvoie une erreur !
            body = const Text('Error');

            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return buildPopupDialog(context,
                      "Un problème inconnu est survenu.", "Oups!", "Fermer");
                });
          } else {
            body = ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: Text(_jobOffer['name']),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: Text(_jobOffer['description']),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: Text(_jobOffer['requires']),
                ),
                TextButton(
                    onPressed: () {
                      logic.applyJobOffer(jobOfferId: widget.jobOfferId);
                    },
                    child: (_applyJobOffer == false)? Text("Je suis intéressé par cette offre !"): Text("vous avez déjà postulé à cette offre"))
              ],
            );
            // body = listView;
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
        body: Center(
            child: Wrap(
          spacing: 100,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 4,
                child: buildJobOffer()),
          ],
        )));
  }
}
