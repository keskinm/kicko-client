import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/end_point.dart';

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

// class _TestPage extends State<TestPage> with UserStateMixin {
class _TestPage extends State<TestPage> {
  late Future<Map> sqlFetchedData;

  // @todo A MOCKER appState.userName JUSTE APRES AVOIR FAIT MARCHER CE TEST
  // String get resumesBucket => "${userGroupSyntax.candidate}/$userName/resumes";

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  onReBuild() {
    setState(() {
      sqlFetchedData = postRequest<Map>("candidate_get_profile", [""], {});
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
