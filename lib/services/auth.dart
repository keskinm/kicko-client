import 'package:kicko/end_point.dart';
import 'package:kicko/services/app_state.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth fAuth = FirebaseAuth.instance;

  Future<Response?> userRegister(
      {required String userGroup,
      required String username,
      required String password,
      required String email,
      required String firebaseUid}) async {
    try {
      Response response = await postRequest("user_register", [
        userGroup
      ], {
        "username": username,
        "password": password,
        "email": email,
        "firebase_id": firebaseUid
      });
      if (response.statusCode == 200) {
        appState.addCredentials(keys: {
          'username': username,
          'password': password,
          'email': email,
          'id': firebaseUid
        });
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
  }

  //@todo rajouter signout pas seulement FireBase mais aussi de l'app.
  Future signOut() async {
    try {
      return await fAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<void> firebaseSignInWithEmailAndPassword(
      String email, String password) async {
    UserCredential firebaseUser = await fAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (firebaseUser == null) {
      throw ('failed to authenticate in FireBase');
    }
  }
}
