import 'package:kicko/professional/main.dart';
import 'package:flutter/material.dart';
import 'dio.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: KickoApp(),
  ));
}

class KickoApp extends StatefulWidget {
  const KickoApp({Key? key}) : super(key: key);

  @override
  _KickoApp createState() => _KickoApp();
}

class _KickoApp extends State<KickoApp>{

  bool _initialized = false;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _initialized = false;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('KICKO'),
        ),


        body: Container(
            alignment: Alignment.center,
            child: Wrap(
                spacing: 100,
                children: [

                  ElevatedButton(
                    child: const Text('Je suis professionel'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProHome()),
                      );
                    },
                  ),

                  ElevatedButton(
                    child: const Text('Je suis candidat'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KickoApp()),
                      );
                    },
                  ),

                ]))

    );
  }
}

