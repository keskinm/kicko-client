import 'package:flutter/material.dart';


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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: Text("POST/GET")
    );
  }


}