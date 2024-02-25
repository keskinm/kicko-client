import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/dio.dart';

import 'package:kicko/syntax.dart';
import 'package:kicko/shared/user.dart';
import 'package:dio/dio.dart';

class TestPage extends StatefulWidget {
  final String isClicked;
  const TestPage({Key? key, this.isClicked = "NO"}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestPage();
  }
}

Future<Map> getProfile() async {
  // String userId = appState.currentUser.id;
  String userId = '';
  String body = '{"id": "$userId"}';

  Response response = await dioHttpPost(
    route: 'candidate_get_profile',
    jsonData: body,
    token: false,
  );

  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception("getProfile HTTP Error");
  }
}

// class _TestPage extends State<TestPage> with UserStateMixin {
class _TestPage extends State<TestPage> {
  Map<String, dynamic> jobOfferFilters = {"city": TextEditingController()};
  Map<String, dynamic> profileJson = {};
  Map<String, dynamic> profileJsonDropDown = {};

  late Future<Map> sqlFetchedData;

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
