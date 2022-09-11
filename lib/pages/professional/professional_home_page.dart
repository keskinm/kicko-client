import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';

import '../../services/app_state.dart';


//@todo how to refactor it in professional home logic?
Future<List> getJobOffers() async {
  String userId = appState.currentUser.id;
  String body = '{"user_id": "$userId"}';
  Response response = await dioHttpPost(
    route: 'get_job_offers',
    jsonData: body,
    token: false,
  );
  return response.data;
}


Future<bool> addJobOffer(
    {required String jobOffer}) async {
  String userId = appState.currentUser.id;
  String body = '{"name": "$jobOffer", "description":"$jobOffer", "requires":"$jobOffer", "user_id": "$userId"}';
  Response response =await dioHttpPost(
    route: 'add_job_offer',
    jsonData: body,
    token: false,
  );

  if (response.statusCode == 200) {

    return true;
  } else {
    return false;
  }

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

  Widget buildPopupDialog(BuildContext context, String message) {
    return AlertDialog(
      title: const Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget buildJobOffers() {return FutureBuilder<List<dynamic>>(
    future: items,
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      Widget body;
      if (snapshot.hasData){
        body = ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final jobOffer = snapshot.data![index];
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: Text(jobOffer['name']),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: Text(jobOffer['description']),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: Text(jobOffer['requires']),
                ),
              ],
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

  Column buildAddJobOffer(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Entrez une nouvelle offre d\'emploi'),
        ),
        ElevatedButton(
          onPressed: () async {
            bool success = await addJobOffer(jobOffer: _controller.text);
            if (success) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProHome()),
              );
            }
            else {
              buildPopupDialog(context, "A problem occurred.");
            }
          },
          child: const Text('Valider'),
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
          children: [
            SizedBox(
                width: 200.0,
                height: 300.0,
                child:buildJobOffers()),

            SizedBox(
                width: 200.0,
                height: 300.0,
                child:buildAddJobOffer(context))
          ],)

    );
  }


}