import 'package:kicko/services/app_state.dart';
import 'package:dio/dio.dart';
import 'package:kicko/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth fAuth = FirebaseAuth.instance;

  Future<Response?> userRegister(
      {required String userGroup,
      required String username,
      required String password,
      required String email,
      required String firebaseUid}) async {
    String json =
        '{"username": "$username","password":"$password", "email":"$email", "firebase_id": "$firebaseUid"}';

    try {
      Response response = await dioHttpPost(
          route: '${userGroup}_register', jsonData: json, token: false);
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

  Future authenticationToken(
      {required String username,
      required String password,
      required String userGroup}) async {
    String body = '{"username": "$username" ,"password":"$password"}';
    Response response = await dioHttpPost(
      route: "${userGroup}_authentication_token",
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("exception ${userGroup}_authentication_token");
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
