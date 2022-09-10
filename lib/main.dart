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
          title: const Text('None'),
        ),


        body: Container(
            alignment: Alignment.center,
            child: Wrap(
                spacing: 100,
                children: [

                  ElevatedButton(
                    child: const Text('Professional'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProHome()),
                      );
                    },
                  ),

                  ElevatedButton(
                    child: const Text('Export'),
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

