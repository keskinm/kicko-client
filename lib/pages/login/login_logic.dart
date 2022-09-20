import 'package:flutter/material.dart';
import 'package:kicko/pages/candidate/candidate_home_page.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/widgets/forms/validator.dart';

import '../../syntax.dart';
import '../professional/professional_home_page.dart';

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
      final bool res = appState.checkToken(await appState.authMethods
          .authenticationToken(
              username: username, password: password, userGroup: userGroup));

      if (res) {
        //Stockage des infos pour connexion auto
        appState
            .addCredentials(keys: {'username': username, 'password': password});
        final res = await appState.authMethods.getCurrentUser(
            token: appState.currentUser.token, userGroup: userGroup);

        await appState.authMethods
            .firebaseSignInWithEmailAndPassword(res['email'], password);

        appState.currentUser.setParameters(res);
        appState.appStatus = AppStatus.connected;
        //Lancement app
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            if (userGroup == userGroupSyntax.professional) {
              return const ProHome();
            } else if (userGroup == userGroupSyntax.candidate) {
              return const CandidateHome();
            } else {
              return Text("unknown user group $userGroup");
            }
          }),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion impossible')),
        );
      }
    }
  }
}
