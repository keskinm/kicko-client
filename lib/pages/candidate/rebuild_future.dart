import 'package:flutter/material.dart';

class RebuildFuture extends StatefulWidget {
  const RebuildFuture({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RebuildFuture();
  }
}

class _RebuildFuture extends State<RebuildFuture> {
  int _counter = 0;
  late Future<String> futureFlag;

  Future<String> setFlag() async {
    // return Future<String>.value(_counter.toString());
    return _counter.toString();
  }

  onReBuild() {
    futureFlag = setFlag();
  }

  @override
  void initState() {
    super.initState();
    print("0");
    onReBuild();
    print("1");
  }

  Widget buildJobOffers() {
    print("2");
    return FutureBuilder<String>(
      future: futureFlag,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        bool? checkBoxValue = true;
        Widget flagChanger = Checkbox(value: checkBoxValue,
          activeColor: Colors.green,
          onChanged:(bool? newValue) async {
            setState(() {
              _counter = _counter + 1;
              print("4");
              // onReBuild();
              print("5");
              futureFlag = Future<String>.value(_counter.toString());
            });
        });

        if (snapshot.hasData) {

          return Wrap(
            children: [Text(snapshot.data!), flagChanger],
          );
        }
        else {
          return Wrap(
            children: [Text("No data ;( ? .."), flagChanger],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenu dans votre tableau de bord !'),
        ),
        body: Wrap(
            spacing: 100,
            children: [
        SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 4,
        child: buildJobOffers()),
    ],
    ));
    }
  }
