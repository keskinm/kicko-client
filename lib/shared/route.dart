import 'package:flutter/material.dart';
import 'package:kicko/syntax.dart';
import 'package:kicko/professional/ui/professional_home_page.dart';
import 'package:kicko/candidate/ui/candidate_home_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/candidate/home": (context) => CandidateHome(),
  "/professional/home": (context) => ProHome()
};

pushSetStateWhenBack(
    BuildContext context, dynamic builder, Function setStates) {
  Navigator.push(context, MaterialPageRoute(builder: builder)).then((_) {
    setStates();
  });
}

popUntilHome(BuildContext context, String userGroup) {
  if (userGroup == userGroupSyntax.professional) {
    Navigator.popUntil(context, ModalRoute.withName('/professional/home'));
    ;
  } else if (userGroup == userGroupSyntax.candidate) {
    Navigator.popUntil(context, ModalRoute.withName('/candidate/home'));
  } else {
    return Text("unknown user group $userGroup");
  }
}

goHome(BuildContext context, String userGroup) {
  if (userGroup == userGroupSyntax.professional) {
    Navigator.pushNamed(context, '/professional/home');
    ;
  } else if (userGroup == userGroupSyntax.candidate) {
    Navigator.pushNamed(context, '/candidate/home');
  } else {
    return Text("unknown user group $userGroup");
  }
}
