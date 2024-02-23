import 'package:flutter/material.dart';

class UserGroupSyntax {
  String professional = "professional";
  String candidate = "candidate";
  late Map titleMap = {candidate: "candidats", professional: "professionnels"};
}

UserGroupSyntax userGroupSyntax = UserGroupSyntax();

class CityAutocompletion extends StatelessWidget {
  final String initialValue;
  final Function selectionCallback;

  static const String allCities = "Toutes les villes";

  const CityAutocompletion(
      {Key? key,
      this.initialValue = allCities,
      required this.selectionCallback})
      : super(key: key);

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
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          Iterable<String> returnConst = [allCities] + _kOptions;
          return returnConst;
        }
        return _kOptions.where((String option) {
          return option
              .toLowerCase()
              .startsWith(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) => selectionCallback(selection),
    );
  }
}
