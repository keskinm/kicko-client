import 'package:flutter/material.dart';
import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

var acs = ActionCodeSettings(
  // URL you want to redirect back to. The domain (www.example.com) for this
  // URL must be whitelisted in the Firebase Console.
    url: 'https://www.example.com/finishSignUp?cartId=1234',
    // This must be true
    handleCodeInApp: true,
    iOSBundleId: 'com.example.ios',
    androidPackageName: 'com.example.android',
    // installIfNotAvailable
    androidInstallApp: true,
    // minimumVersion
    androidMinimumVersion: '12');

void sendEmail(
    {required String emailAuth}) async {
  print("ici");
  print(emailAuth);
  print("ici1");
  FirebaseAuth.instance.sendSignInLinkToEmail(
      email: emailAuth, actionCodeSettings: acs)
      .catchError((onError) => print('Error sending email verification $onError'))
      .then((value) => print('Successfully sent email verification'));
}


class ProHome extends StatefulWidget {
  const ProHome({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _ProHome();
  }
}

class _ProHome extends State<ProHome> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Email'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: buildColumn(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Adresse mail :'),
        ),
        ElevatedButton(
          onPressed: () {

            sendEmail(emailAuth: _controller.text);

          },
          child: const Text('Entrez email'),
        ),
      ],
    );
  }


}