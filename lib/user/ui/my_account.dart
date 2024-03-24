import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/end_point.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/user/domain/my_account_logic.dart';
import 'package:kicko/main.dart';

import 'medias.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAccount();
  }
}

class _MyAccount extends State<MyAccount> {
  late Map<String, dynamic> userJson;
  late Future<String> imageDownloadURL;
  late Future<Map<String, dynamic>> profile;
  AccountLogic logic = AccountLogic();

  String get imagesBucket =>
      '${appState.userGroup}/${appState.currentUser.username}/profile_images';

  String updateRoute = "${appState.userGroup}_update_profile";
  String profileUrl = "${appState.userGroup}_get_profile";

  onReBuild() {
    setState(() {
      profile = getRequest(profileUrl, [appState.currentUser.id]);
      imageDownloadURL = logic.getProfileImage(profile, imagesBucket, context);
    });
  }

  @override
  void initState() {
    super.initState();
    onReBuild();
  }

  Widget buildAccount() {
    return FutureBuilder<dynamic>(
        future: imageDownloadURL,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          Widget body;
          if (snapshot.hasData) {
            body = UIImage(
                snapshot.data!, context, imagesBucket, updateRoute, onReBuild);
          } else if (snapshot.hasError) {
            body = Text('Error: ${snapshot.error}');
          } else {
            body = const CircularProgressIndicator(
              color: Colors.orangeAccent,
            );
          }

          return body;
        });
  }

  Widget buildDeleteAccount() {
    TextEditingController passwordController = TextEditingController();

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
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      String password = passwordController.text;

                      if (password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Veuillez entrer votre mot de passe.'),
                          ),
                        );
                        return;
                      }

                      await appState.deleteAccount(context, password);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const KickoApp()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Supprimer mon compte",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Retour",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Text(
        "Supprimer mon compte",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppBar("", context),
        body: Center(
            child: Column(
          children: [
            buildAccount(),
            buildDeleteAccount(),
          ],
        )));
  }
}
