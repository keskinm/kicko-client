import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/pages/professional/professional_home_style.dart';
import 'package:kicko/dio.dart';
import 'package:kicko/services/app_state.dart';


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


class ProHome extends StatefulWidget {
  const ProHome({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _ProHome();
  }
}

class _ProHome extends State<ProHome> {
  ProfessionalHomeLogic logic = ProfessionalHomeLogic();
  ProfessionalHomeStyle style = ProfessionalHomeStyle();

  Future<List<dynamic>> items = getJobOffers();

  Widget buildPopupDialog(BuildContext context, String message) {
    return AlertDialog(
      title: const Text('Oups !'),
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
          child: const Text('Fermer'),
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
        Form(
          key: logic.formKey,
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) =>
                      logic.nonNullable(value: value, key:"jobOfferName"),
                      // logic.validateJobOfferName(value: value),

                  decoration:
                  style.inputDecoration(hintText: 'Nom de l\'offre d\'emploi'),                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) =>
                      logic.nonNullable(value: value, key:"jobOfferDescription"),
                      // logic.validateJobOfferDescription(value: value),
                  decoration:
                  style.inputDecoration(hintText: 'Description'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) =>
                      logic.nonNullable(value: value, key:"jobOfferRequires"),
                      // logic.validateJobOfferRequires(value: value),

                  decoration:
                  style.inputDecoration(hintText: 'Compétences ou points imports requis'),
                ),
              ),
              MaterialButton(
                onPressed: () => logic.validateJobOffer(context: context),
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.red])),
                  child: const Center(
                    child: Text(
                      'Valider',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
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
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/4,
                child:buildJobOffers()),

            SizedBox(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/4,
                child:buildAddJobOffer(context))
          ],)

    );
  }


}