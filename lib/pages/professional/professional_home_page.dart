import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/pages/professional/professional_home_style.dart';

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


  Widget buildJobOffers() {
    return FutureBuilder<List<dynamic>>(
      future: logic.getJobOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
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
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool success = await logic.deleteJobOffer(jobOffer["id"]);

                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProHome()),
                        );
                      } else {
                        logic.buildPopupDialog(context,
                            "Nous avons rencontré un problème lors de la suppression de votre offre d'emploi.");
                      }

                    },
                  )
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          body = Text('Error: ${snapshot.error}');
        } else {
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
                      logic.nonNullable(value: value, key: "jobOfferName"),
                  decoration: style.inputDecoration(
                      hintText: 'Nom de l\'offre d\'emploi'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) => logic.nonNullable(
                      value: value, key: "jobOfferDescription"),
                  decoration: style.inputDecoration(hintText: 'Description'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) =>
                      logic.nonNullable(value: value, key: "jobOfferRequires"),
                  decoration: style.inputDecoration(
                      hintText: 'Compétences ou points imports requis'),
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
        body: Wrap(
          spacing: 100,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 4,
                child: buildJobOffers()),
            SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 4,
                child: buildAddJobOffer(context))
          ],
        ));
  }
}
