import 'package:flutter/material.dart';


class UserGroupSyntax {
  String professional = "professional";
  String candidate = "candidate";
}

UserGroupSyntax userGroupSyntax = UserGroupSyntax();



class CityAutocompletion extends StatelessWidget {
  final State parent;
  final String initialValue;
  final Function selectionCallback;

  const CityAutocompletion(
      {Key? key, required this.parent, required this.initialValue, required this.selectionCallback})
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
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.toLowerCase().startsWith(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) => selectionCallback(selection),
    );
  }
}