import 'package:flutter/material.dart';

import 'package:kicko/pages/common.dart';
import 'candidate_home_logic.dart';
import 'candidate_home_style.dart';

class CandidateHome extends StatefulWidget {
  const CandidateHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CandidateHome();
  }
}

class _CandidateHome extends State<CandidateHome> {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  CandidateHomeLogic logic = CandidateHomeLogic();
  CandidateHomeStyle style = CandidateHomeStyle();
  late Future<List> jobOffers;

  onReBuild() {
    jobOffers = logic.getJobOffers(jobOfferFilters);
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  Widget buildJobOffers() {
    return FutureBuilder<List<dynamic>>(
      future: jobOffers,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget cityFilter = TextField(
          controller: jobOfferFilters["city"],
          decoration: InputDecoration(
            hintText: 'Filtrer par ville',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  onReBuild();
                });
              },
              icon: const Icon(Icons.check_box),
            ),
          ),
        );

        Widget body;
        if (snapshot.hasData) {
          if (snapshot.data![0].containsKey("error")) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return buildPopupDialog(
                      context,
                      "Un problème est survenu dans votre filtre par villes",
                      "Oups!",
                      "Fermer");
                });
          }

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
                    icon: const Icon(Icons.add_call),
                    onPressed: () async {},
                  )
                ],
              );
            },
          );
          body = Column(children: [cityFilter, Expanded(child: listView)]);
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
                child: buildJobOffers()),
          ],
        ));
  }
}
