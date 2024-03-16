import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/syntax.dart';
import 'package:kicko/services/auth.dart';
import 'package:kicko/user/models/user.dart';

import 'firebase.dart';
import 'package:provider/provider.dart';
import 'package:kicko/end_point.dart';

AppState appState = AppState();

enum AppStatus {
  init,
  login,
  connected,
  disconnected,
  unknownPlatform,
}

class AppState {
  AppState();

  String language = "french";

  late Map<dynamic, dynamic> platformState;

  late String serverUrl;

  late User currentUser = User();
  late String userGroup;

  AppStatus appStatus = AppStatus.init;

  AuthMethods authMethods = AuthMethods();



  bool checkToken(token) {
    if (token.containsKey('token')) {
      currentUser.token = token['token'];
      return true;
    } else {
      return false;
    }
  }

  Future deleteAccount(BuildContext context, String password) async {
    if (appState.checkToken(await postRequest("authentication_token", [
      userGroup
    ], {
      "username": currentUser.username,
      "password": password
    }).catchError((Object e, StackTrace stackTrace) {
      throw Exception(e.toString());
    }))) {
      Response response = await getRequest("delete_account", [userGroup]);

      if (response.statusCode == 200) {
        if (userGroup == userGroupSyntax.professional) {
          await Provider.of<FireBaseServiceInterface>(context, listen: false)
              .deleteFireBaseStorageBucket(
                  '$userGroup/${appState.currentUser.username}/business_images');

          await Provider.of<FireBaseServiceInterface>(context, listen: false)
              .deleteFireBaseStorageBucket(
                  '$userGroup/${appState.currentUser.username}/job_offer_qr_codes');
        } else if (userGroup == userGroupSyntax.candidate) {
          await Provider.of<FireBaseServiceInterface>(context, listen: false)
              .deleteFireBaseStorageBucket(
                  '$userGroup/${appState.currentUser.username}/resumes');
        }

        await Provider.of<FireBaseServiceInterface>(context, listen: false)
            .deleteUserFromFireBase(currentUser.email, password);
        appState.zero();
      } else {
        throw Exception("Server failed deleteAccount");
      }
    } else {
      throw Exception("Check token returned false");
    }
  }

  zero() {
    currentUser = User();
    userGroup = "";
  }
}
