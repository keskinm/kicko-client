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
  late Future<List> jobOffer;

  onReBuild() {}

  @override
  void initState() {
    super.initState();
    jobOffer = logic.getJobOffers({"id": widget.jobOfferId});
  }

  Widget buildJobOffer() {
    return FutureBuilder<List<dynamic>>(
      future: jobOffer,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            body = const Text("Un problème inconnu est survenu.");
          } else if (snapshot.data![0].containsKey("error")) {
            body = const Text('Error');

            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return buildPopupDialog(context,
                      "Un problème inconnu est survenu.", "Oups!", "Fermer");
                });
          } else {
            body = ListView.builder(
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
                    TextButton(
                        onPressed: () {
                          logic.applyJobOffer(jobOfferId: widget.jobOfferId);
                        },
                        child:
                            const Text("Je suis intéressé par cette offre !"))
                  ],
                );
              },
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
