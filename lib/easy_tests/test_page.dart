import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/dio.dart';

import 'package:kicko/syntax.dart';
import 'package:kicko/shared/user.dart';
import 'package:dio/dio.dart';

class TestPage extends StatefulWidget {
  // @todo A changer le isClicked avec un onpressed navigator qui repush sur la meme page et qui
  // @todo change la value en yes.
  // @todo Tester push puis back fetch et met à jour de la data.
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
  // late Future<Map> sqlFetchedData;

  // @todo A MOCKER appState.userName JUSTE APRES AVOIR FAIT MARCHER CE TEST
  // String get resumesBucket => "${userGroupSyntax.candidate}/$userName/resumes";

  @override
  void initState() {
    super.initState();
    // onReBuild();
  }

  onReBuild() {
    setState(() {
      // sqlFetchedData = getProfile();
    });
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
