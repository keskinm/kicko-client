import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/pages/login/login_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/syntax.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'KICKO!',
    home: const KickoApp(),
    theme: ThemeData(
      textTheme: const TextTheme(
          displayMedium: TextStyle(backgroundColor: Colors.deepOrangeAccent),
          displaySmall: TextStyle(backgroundColor: Colors.deepOrangeAccent)),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.deepOrangeAccent, //<-- SEE HERE
      ),
    ),
  ));
}

class KickoApp extends StatefulWidget {
  const KickoApp({Key? key}) : super(key: key);

  @override
  _KickoApp createState() => _KickoApp();
}

class _KickoApp extends State<KickoApp> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildRow(String text, String userGroup) {
    Widget child = DefaultTextStyle(
      style: const TextStyle(fontSize: 40.0, color: Colors.deepOrangeAccent),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText(text),
        ],
        isRepeatingAnimation: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(userGroup: userGroup)),
          );
        },
      ),
    );

    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 40.0,
        fontFamily: 'Horizon',
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            ColorizeAnimatedText(
              "Je suis :",
              textStyle: const TextStyle(
                fontSize: 30.0,
                fontFamily: 'Horizon',
              ),
              colors: [Colors.deepOrange, Colors.yellow],
            ),
          ],
        ),

        SizedBox(
            height: MediaQuery.of(context).size.height / 8), // <-- Set height

        buildRow("CANDIDAT", userGroupSyntax.candidate),

        SizedBox(
            height: MediaQuery.of(context).size.height / 8), // <-- Set height

        buildRow("PROFESSIONEL", userGroupSyntax.professional),
      ],
    )));

    return Scaffold(appBar: protoAppBar("Kicko!"), body: body);
  }
}
