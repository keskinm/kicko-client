import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';

import '../../services/app_state.dart';


//@todo how to refactor it in professional home logic?
Future<List> getJobOffers() async {
  String userId = appState.currentUser.id;
  String body = '{"id": "$userId"}';
  Response response = await dioHttpPost(
    route: 'get_job_offers',
    jsonData: body,
    token: false,
  );
  return response.data;
}


void addJobOffer(
    {required String jobOffer}) async {
  String userId = appState.currentUser.id;
  String body = '{"name": "$jobOffer", "description":"$jobOffer", "requires":"$jobOffer", "id": "$userId"}';
  Response response =await dioHttpPost(
    route: 'update_job_offers',
    jsonData: body,
    token: false,
  );
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

  Future<List<dynamic>> items = getJobOffers();

  Widget buildJobOffers() {return FutureBuilder<List<dynamic>>(
    future: items,
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      Widget body;
      if (snapshot.hasData){
        body = ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: snapshot.data!.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final jobOffer = snapshot.data![index];
            return ListTile(
              title: Text(jobOffer['name']),
              subtitle: ListTile(
                title: Text('Description: ' + jobOffer["description"] + '\n'),
                subtitle: ListTile(
                  title: Text('Requires: ' + jobOffer["requires"]),
                ),
              ),
            );
          },
        );
      }
      else if (snapshot.hasError) {
        body = Text('Error: ${snapshot.error}');
      }
      else {
        body = const Text('Awaiting result...');
      }
      return Scaffold(body: body);
    },
  );
  }

  Column buildUpdateJobOffer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Backlog'),
        ),
        ElevatedButton(
          onPressed: () {

            addJobOffer(jobOffer: _controller.text);

          },
          child: const Text('Merge Backlog'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenu dans votre tableau de bord !'),
        ),
        body: Wrap(spacing: 100,
        children: [buildJobOffers(), buildUpdateJobOffer()],)
    );
  }


}