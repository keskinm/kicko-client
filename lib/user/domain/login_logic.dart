import 'package:flutter/material.dart';
import 'package:kicko/end_point.dart';
import 'package:kicko/shared/common.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/shared/route.dart';
import 'package:kicko/shared/validator.dart';

class LoginLogic {
  final formKey = GlobalKey<FormState>();
  late String username;
  late String password;

  Validator validator = Validator();

  String? validatePassword({required String? value}) {
    if (!validator.validatePassword(value: value)) {
      return 'Doit contenir au moins 8 caractères.';
    } else {
      password = value!;
      return null;
    }
  }

  String? validateUsername({required String? value}) {
    if (!validator.validateUsername(value: value)) {
      return 'Doit contenir au moins 4 caractères.';
    } else {
      username = value!;
      return null;
    }
  }

  Future<void> validateLogin(
      {required BuildContext context, required userGroup}) async {
    if (formKey.currentState!.validate()) {
      appState.userGroup = userGroup;
      final bool res = appState.checkToken(await postRequest(
              "authentication_token",
              [userGroup],
              {"username": username, "password": password})
          .catchError((Object e, StackTrace stackTrace) {
        showAlert(context, e.toString(), "oups", "Fermer");
      }));

      if (res) {
        //Stockage des infos pour connexion auto
        appState
            .addCredentials(keys: {'username': username, 'password': password});

        final res = await getRequest("get_current_user", [userGroup])
            .catchError((Object e, StackTrace stackTrace) {
          showAlert(context, e.toString(), "oups", "Fermer");
        });

        await appState.authMethods
            .firebaseSignInWithEmailAndPassword(res["data"]['email'], password);

        appState.currentUser.setParameters(res["data"]);
        appState.appStatus = AppStatus.connected;
        //Lancement app
        goHome(context, userGroup);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion impossible')),
        );
      }
    }
  }
}
