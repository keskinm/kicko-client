import 'package:kicko/professional/main.dart';
import 'package:flutter/material.dart';
import 'dio.dart';


void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

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
                        MaterialPageRoute(builder: (context) => const FirstRoute()),
                      );
                    },
                  ),

                ]))

    );
  }
}

