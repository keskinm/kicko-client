import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/widgets/forms/validator.dart';

import '../../syntax.dart';
import '../candidate/candidate_home_page.dart';
import 'package:kicko/pages/common.dart';
import '../professional/professional_home_page.dart';

class RegisterLogic {
  final formKey = GlobalKey<FormState>();
  Validator validator = Validator();

  late String username;
  late String password;
  late String email;

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

  String? validateEmail({required String? value}) {
    if (!validator.validateEmail(value: value)) {
      return 'Email invalide';
    } else {
      email = value!;
      return null;
    }
  }

  Future<String> createUserFromFireBase(String email, String password) async {
    try {
      UserCredential fireBaseResponse = await appState.authMethods.fAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? fireBaseResponseUser = fireBaseResponse.user;
      dynamic uid = fireBaseResponseUser != null
          ? fireBaseResponseUser.uid
          : appState.currentUser.id;
      return uid;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future deleteUserFromFireBase(String email, String password) async {
    try {
      UserCredential firebaseUser = await appState.authMethods.fAuth
          .signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.user!.delete();
      await appState.authMethods.fAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  void validateRegister(
      {required BuildContext context, required userGroup}) async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription')),
      );
      appState.userGroup = userGroup;
      String firebaseUid = await createUserFromFireBase(email, password);
      //Formulaire ok requete /register
      Response? response = await appState.authMethods.userRegister(
          userGroup: userGroup,
          username: username,
          password: password,
          email: email,
          firebaseUid: firebaseUid);

      if (response == null) {
        await deleteUserFromFireBase(email, password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('XMLHttpRequest error.'),
        ));
      } else {
        //Compte créé
        if (response.statusCode == 200) {
          await appState.authMethods
              .firebaseSignInWithEmailAndPassword(email, password);

          if (appState.checkToken(await appState.authMethods
              .authenticationToken(
                  username: username, password: password, userGroup: userGroup)
              .catchError((Object e, StackTrace stackTrace) {
            showAlert(context, e.toString(), "oups", "Fermer");
          }))) {
            final res = await appState.authMethods
                .getCurrentUser(
                    token: appState.currentUser.token, userGroup: userGroup)
                .catchError((Object e, StackTrace stackTrace) {
              showAlert(context, e.toString(), "oups", "Fermer");
            });

            appState.currentUser.setParameters(res);
            appState.appStatus = AppStatus.connected;
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
          //Erreur création compte, (email / username deja utilisé )
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('error ${response.data}'),
          ));
        }
      }
    }
  }
}
