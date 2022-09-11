import 'package:kicko/services/app_state.dart';
import 'package:dio/dio.dart';
import 'package:kicko/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AuthMethods {
  final FirebaseAuth fAuth = FirebaseAuth.instance;

  Future<Response> userRegister(
      {required String username,
        required String password,
        required String email,
        required String firebaseUid}) async {

    String json =
        '{"username": "$username","password":"$password", "email":"$email", "firebase_id": "$firebaseUid"}';
    print('/userRegister');
    Response response =
    await dioHttpPost(route: 'user_register', jsonData: json, token: false);
    print(response.data);
    if (response.statusCode == 200) {

      appState.addCredentials(
          keys: {'username': username, 'password': password,'email': email, 'id': firebaseUid});

      return response;
    } else {
      return response;
    }
  }

  Future authenticationToken(
      {required String username, required String password}) async {
    String body = '{"username": "$username" ,"password":"$password"}';
    Response response = await dioHttpPost(
      route: 'authentication-token',
      jsonData: body,
      token: false,
    );
    return response.data;
  }


  Future getCurrentUser({required String token}) async {
    Response response = await dioHttpGet(route: 'user', token: true);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return {'error' : 'user not found'};
    }
  }

  //@todo rajouter signout pas seulement FireBase mais aussi de l'app.
  Future signOut() async {
    try {
      return await fAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> firebaseSignInWithEmailAndPassword(String email, String password) async {
    UserCredential firebaseUser = await fAuth.signInWithEmailAndPassword(email: email, password: password);
    if (firebaseUser == null){
      throw('failed to authenticate in FireBase');
    }
  }

}





