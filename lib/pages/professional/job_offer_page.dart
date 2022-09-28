import 'package:flutter/material.dart';

import 'package:kicko/pages/job_offers_logic.dart';
import 'professional_home_logic.dart';
import 'professional_home_style.dart';

class ProfessionalJobOfferPage extends StatefulWidget {
  final String jobOfferId;
  const ProfessionalJobOfferPage({Key? key, required this.jobOfferId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfessionalJobOfferPage();
  }
}

class _ProfessionalJobOfferPage extends State<ProfessionalJobOfferPage> {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  ProfessionalHomeLogic logic = ProfessionalHomeLogic();
  JobOfferLogic jobOfferLogic = JobOfferLogic();
  ProfessionalHomeStyle style = ProfessionalHomeStyle();
  late Future<Map> jobOffer;
  late Future<List> appliers;

  onReBuild() {}

  @override
  void initState() {
    super.initState();
    jobOffer = jobOfferLogic.getJobOffer(jobOfferId: widget.jobOfferId);
    appliers = logic.appliers(jobOfferId: widget.jobOfferId);
  }

  Widget buildJobOffer() {
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: jobOffer,
      builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          Map _jobOffer = snapshot.data!;

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

  Widget buildAppliers() {
    return FutureBuilder<List>(
      future: appliers,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        Widget body;
        if (snapshot.hasData) {

          body = ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final _applier = snapshot.data![index];
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.amber[600],
                    child: Text(_applier['username']),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[500],
                    child: Text(_applier['l_study_level']),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[100],
                    child: Text(_applier['l_sex']),
                  ),
                ],
              );
            },
          );
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
                SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 4,
                    child: buildAppliers()),
              ],
            )));
  }
}
