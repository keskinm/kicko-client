import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/services/app_state.dart';

import '../../main.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAccount();
  }
}

class _MyAccount extends State<MyAccount> {
  late Map<String, dynamic> userJson;

  onReBuild() {}

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  // Widget buildAccount() {
  //   return FutureBuilder<dynamic>(
  //       future: userJson,
  //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //         Widget body;
  //         if (snapshot.hasData) {
  //
  //           body = const Text("");
  //         } else if (snapshot.hasError) {
  //           body = Text('Error: ${snapshot.error}');
  //         } else {
  //           body = const CircularProgressIndicator(
  //             color: Colors.orangeAccent,
  //           );
  //         }
  //
  //         return body;
  //       });
  // }

  Widget buildDeleteAccount() {
    return TextButton(
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                          onPressed: () async {
                            await appState.deleteAccount(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const KickoApp()),
                                (route) => false);
                          },
                          child: Text(
                              "Êtes vous sûr de vouloir supprimer votre compte ?",
                              style: Theme.of(context).textTheme.displaySmall)),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Retour",
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                  ],
                );
              });
        },
        child: Text("Supprimer mon compte",
            style: Theme.of(context).textTheme.displayMedium));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            userAppBar("Bienvenu dans la gestion de votre compte !", context),
        body: Center(
            child: Column(
          children: [
            // buildAccount(),

            buildDeleteAccount(),
          ],
        )));
  }
}
