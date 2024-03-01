import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kicko/syntax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kicko/services/auth.dart';
import 'package:kicko/user/models/user.dart';

import 'database.dart';
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

  late SharedPreferences sharedPreferences;
  AppStatus appStatus = AppStatus.init;

  AuthMethods authMethods = AuthMethods();

  Future<AppStatus> init() async {
    if (await getCredentials()) {
      appStatus = AppStatus.login;

      await authMethods.firebaseSignInWithEmailAndPassword(
          currentUser.email, currentUser.password);

      if (checkToken(await postRequest("authentication_token", [
        userGroup
      ], {
        "username": currentUser.username,
        "password": currentUser.password
      }))) {
        final res = await getRequest("get_current_user", [userGroup])
            .catchError((Object e, StackTrace stackTrace) {
          throw Exception(e.toString());
        });
        currentUser.setParameters(res["data"]);
        appStatus = AppStatus.connected;
        return AppStatus.connected;
      } else {
        appStatus = AppStatus.disconnected;

        return AppStatus.disconnected;
      }
    } else {
      appStatus = AppStatus.disconnected;
      return AppStatus.disconnected;
    }
  }

  Future<bool> getCredentials() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return checkCredentials(keys: sharedPreferences);
  }

  void addCredentials({required Map<String, String> keys}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    keys.forEach((key, value) {
      appState.sharedPreferences.setString(key, value);
    });
  }

  bool checkCredentials({required SharedPreferences keys}) {
    if (keys.containsKey('username') &&
        keys.get('username') != null &&
        keys.containsKey('password') &&
        keys.get('password') != null) {
      currentUser.username = keys.get('username').toString();
      currentUser.password = keys.get('password').toString();
      return true;
    } else {
      return false;
    }
  }

  bool checkToken(token) {
    if (token.containsKey('token')) {
      currentUser.token = token['token'];
      return true;
    } else {
      return false;
    }
  }

  Future deleteAccount(BuildContext context) async {
    if (appState.checkToken(await postRequest("authentication_token", [
      userGroup
    ], {
      "username": currentUser.username,
      "password": currentUser.password
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
            .deleteUserFromFireBase(currentUser.email, currentUser.password);
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
