import 'package:flutter/material.dart';

import 'package:kicko/pages/job_offers_logic.dart';
import 'package:kicko/pages/candidate_logic.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/syntax.dart';
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
  CandidateLogic candidateLogic = CandidateLogic();
  ProfessionalHomeStyle style = ProfessionalHomeStyle();
  String userId = appState.currentUser.id;
  late Future<Map> jobOffer;
  late Future<List> appliers;
  late Future<Map> candidateSyntax;

  Map<String, dynamic> appliersFilterJson = {};
  Map<String, dynamic> appliersFilterJsonDropDown = {};

  onReBuild() {
    appliers = logic.appliers(jobOfferId: widget.jobOfferId, filters: appliersFilterJson);
  }

  @override
  void initState() {
    super.initState();
    candidateSyntax = candidateLogic.getCandidateSyntax(userGroup: userGroupSyntax.professional, userId: userId);
    jobOffer = jobOfferLogic.getJobOffer(jobOfferId: widget.jobOfferId);
    onReBuild();
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
        setState(() {
          appliersFilterJson[key] = list.indexOf(value);
          appliersFilterJsonDropDown[key] = list.indexOf(value);
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

  Widget buildAppliers() {
    return FutureBuilder<List>(
      future: Future.wait([appliers, candidateSyntax]),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          Widget filters;
          Widget listView;

          List _appliers = snapshot.data![0];
          Map _candidateSyntax = snapshot.data![1];

          List<Widget> dropDownButtons = [];
          for (String key in _candidateSyntax.keys)  {
            if (appliersFilterJsonDropDown.containsKey(key)) {
              appliersFilterJson[key] = appliersFilterJsonDropDown[key];}
            else {
              appliersFilterJson[key] = 0;
            }
            dropDownButtons.add(buildDropDown(key, _candidateSyntax[key], appliersFilterJson[key]),);
          }

          filters = Column(
            children: dropDownButtons+[
              TextButton(onPressed: () async {
                setState(() {
                  onReBuild();
                });

              }, child: const Text("Appliquer filtres"))
            ],
          );

          listView = ListView.builder(
            itemCount: _appliers.length,
            itemBuilder: (context, index) {
              final _applier = _appliers[index];
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

          body = Column(children: [filters, Expanded(child: listView)],);

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
