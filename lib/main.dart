import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/user/ui/login_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kicko/syntax.dart';
import 'firebase_options.dart';
import 'package:kicko/logger.dart';
import 'package:provider/provider.dart';
import 'package:kicko/services/firebase.dart';
import 'package:kicko/get_it_service_locator.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  setupServiceLocator();
  Logger.setLogLevel(LogLevel.info);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// @todo USE MULTIPROVIDER https://pub.dev/documentation/provider/latest/provider/MultiProvider-class.html
// IF WE OPT FOR THIS SOLUTION !!

  runApp(
    Provider<FireBaseServiceInterface>(
      create: (_) => FireBaseService(), // Provide your Firestore service
      child: MaterialApp(
        title: 'KICKO!',
        debugShowCheckedModeBanner: false,
        home: const KickoApp(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
              displayLarge:
                  TextStyle(backgroundColor: Color.fromARGB(255, 240, 236, 10)),
              displayMedium:
                  TextStyle(backgroundColor: Color.fromARGB(255, 240, 236, 10)),
              displaySmall: TextStyle(
                  backgroundColor: Color.fromARGB(255, 240, 236, 10))),
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    ),
  );
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
    Widget child = TextButton(
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(userGroup: userGroup)),
            ),
        child: Text(text, style: TextStyle(fontSize: 50)));

    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 40.0,
        fontFamily: 'Horizon',
      ),
      child: child,
    );
  }

  Widget buildBottomPanel() {
    return Column(
      children: [
        AnimatedTextKit(
          isRepeatingAnimation: true,
          animatedTexts: [
            ColorizeAnimatedText(
              "The job is yours",
              textStyle: const TextStyle(
                fontSize: 30.0,
                fontFamily: 'Horizon',
              ),
              colors: [const Color.fromARGB(255, 23, 10, 6), Colors.yellow],
            ),
          ],
        ),
        Text("3 rue du 11 Novembre 42500 Le Chambon-Feugerolles"),
        Text("Contact: 07 80 13 56 88"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 8),
        buildRow("CANDIDAT", userGroupSyntax.candidate),
        SizedBox(height: MediaQuery.of(context).size.height / 8),
        buildRow("PROFESSIONEL", userGroupSyntax.professional),
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        buildBottomPanel()
      ],
    )));

    return Scaffold(body: body);
  }
}
