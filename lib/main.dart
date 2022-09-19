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

  runApp(const MaterialApp(
    title: 'KICKO!',
    home: KickoApp(),
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

  @override
  Widget build(BuildContext context) {
    Container container;

    return Scaffold(
        appBar: AppBar(
          title: const Text('First Route'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Wrap(spacing: 100, children: [
              ElevatedButton(
                child: const Text('Je suis professionel'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(userGroup: userGroupSyntax.professional)),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Je suis candidat'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(userGroup: userGroupSyntax.candidate)),
                  );
                },
              ),
            ])));
  }
}
