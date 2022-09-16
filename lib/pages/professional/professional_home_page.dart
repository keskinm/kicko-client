import 'package:flutter/material.dart';
import 'package:kicko/pages/professional/professional_home_logic.dart';
import 'package:kicko/pages/professional/professional_home_style.dart';


class CityAutocompletion extends StatelessWidget {
  final _ProHome parent;
  const CityAutocompletion({Key? key, required this.parent}) : super(key: key);

  static const List<String> _kOptions = <String>[
    'Paris',
    'Lyon',
    'Saint-Etienne',
    'Andrézieux-Bouthéon',
    'Lille',
    'Bordeaux',
    'Clermont-Ferrand',
    'Gerzat',
    'Cébazat'
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        parent.logic.nonNullable(value: selection, key: "city", jsonModel: parent.logic.businessJson);
      },
    );
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
  ProfessionalHomeLogic logic = ProfessionalHomeLogic();
  ProfessionalHomeStyle style = ProfessionalHomeStyle();

  Container buildContainerWithText(String text) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.purple),
              top: BorderSide(color: Colors.purple))),
      child: Text(text),
    );
  }

  Widget buildBusiness() {
    return FutureBuilder<Map<String, dynamic>>(
      future: logic.getBusiness(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Widget body;
        if (snapshot.hasData) {

          List<Widget> regularFields = [];
          List<String> fields = ["name"];
          for (final String field in fields) {

            // regularFields.add(value);
          }

          Widget cityChild;
          Widget nameChild;
          if (snapshot.data!.containsKey("city")) {
            cityChild = buildContainerWithText(snapshot.data!["city"]);
          }
          else {
            cityChild = CityAutocompletion(parent: this);
          }

          if (snapshot.data!.containsKey("name")) {
            nameChild = buildContainerWithText(snapshot.data!["name"]);
          }
          else {
            nameChild = Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.purple),
                      top: BorderSide(color: Colors.purple))),
              child: TextFormField(
                validator: (value) =>
                    logic.nonNullable(value: value, key: "name", jsonModel: logic.businessJson),
                decoration: style.inputDecoration(
                    hintText: 'Nom de votre entreprise'),
              ),
            );
          }

          MaterialButton endChild = MaterialButton(
            onPressed: () => logic.validateBusiness(context: context),
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.red])),
              child: const Center(
                child: Text(
                  'Enregistrer les modifications',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );

          return Form(
              key: logic.businessForm,
              child: Column(
              children: <Widget>[
                nameChild,
                cityChild,
                endChild
              ]));
        } else if (snapshot.hasError) {
          body = Text('Error: ${snapshot.error}');
        } else {
          body = const Text('Chargement...');
        }
        return Scaffold(body: body);
      },
    );
  }

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
          key: logic.jobOfferForm,
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.purple),
                        top: BorderSide(color: Colors.purple))),
                child: TextFormField(
                  validator: (value) =>
                      logic.nonNullable(value: value, key: "name", jsonModel: logic.jobOfferJson),
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
                      value: value, key: "description", jsonModel: logic.jobOfferJson),
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
                      logic.nonNullable(value: value, key: "requires", jsonModel: logic.jobOfferJson),
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
                child: buildBusiness()),
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
