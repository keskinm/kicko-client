import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/widgets/forms/validator.dart';

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

  void validateRegister({required BuildContext context, required pushTo}) async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription')),
      );

      String firebaseUid = await createUserFromFireBase(email, password);
      //Formulaire ok requete /register
      Response response = await appState.authMethods.userRegister(
          username: username,
          password: password,
          email: email,
          firebaseUid: firebaseUid);
      //Compte créé
      if (response.statusCode == 200) {
        await appState.authMethods
            .firebaseSignInWithEmailAndPassword(email, password);

        if (appState.checkToken(await appState.authMethods
            .authenticationToken(username: username, password: password))) {

          final res = await appState.authMethods
              .getCurrentUser(token: appState.currentUser.token);

          appState.currentUser.setParameters(res);
          appState.appStatus = AppStatus.connected;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pushTo),
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
