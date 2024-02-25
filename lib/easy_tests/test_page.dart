import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';

import 'package:kicko/syntax.dart';
import 'package:kicko/shared/user.dart';

class TestPage extends StatefulWidget {
  final String isClicked;
  const TestPage({Key? key, this.isClicked = "NO"}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestPage();
  }
}


// class _TestPage extends State<TestPage> with UserStateMixin {
class _TestPage extends State<TestPage> {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  Map<String, dynamic> profileJson = {};
  Map<String, dynamic> profileJsonDropDown = {};

  // @todo A MOCKER DIO HTTP JUSTE APRES AVOIR FAIT MARCHER CE TEST
  // late Future<Map> profile;

  // @todo A MOCKER appState.userName JUSTE APRES AVOIR FAIT MARCHER CE TEST
  // String get resumesBucket => "${userGroupSyntax.candidate}/$userName/resumes";

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: menuAppBar("Bienvenu dans votre tableau de bord !", context),
        body: Center(
            child: Column(
          children: [Text("coucou")],
        )));
  }
}
