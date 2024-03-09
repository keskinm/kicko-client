import 'package:flutter/material.dart';
import 'package:kicko/end_point.dart';

import 'package:kicko/appbar.dart';
import 'package:kicko/services/app_state.dart';
import '../domain/candidate_home_logic.dart';
import '../../styles/candidate_home_style.dart';

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

  onReBuild() {
    setState(() {
      appliedJobOffer = getRequest<bool>(
          "applied_job_offer", [appState.currentUser.id, widget.jobOfferId]);
    });
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
    jobOffer = getRequest("candidate_get_job_offer", [widget.jobOfferId]);
  }

  Widget buildJobOffer() {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([jobOffer, appliedJobOffer]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          Map _jobOffer = snapshot.data![0];
          bool _applyJobOffer = snapshot.data![1];

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
                  onPressed: () async {
                    await getRequest("apply_job_offer",
                        [appState.currentUser.id, widget.jobOfferId]);
                    onReBuild();
                  },
                  child: (_applyJobOffer == false)
                      ? Text("Je suis intéressé par cette offre !")
                      : Text("vous avez déjà postulé à cette offre"))
            ],
          );
          // body = listView;
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
        appBar: simpleAppBar("Offre d'emploi"),
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
