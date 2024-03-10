import 'package:flutter/material.dart';
import 'package:kicko/syntax.dart';
import 'package:kicko/professional/ui/professional_home_page.dart';
import 'package:kicko/candidate/ui/candidate_home_page.dart';

pushSetStateWhenBack(
    BuildContext context, dynamic builder, Function setStates) {
  Navigator.push(context, MaterialPageRoute(builder: builder)).then((_) {
    setStates();
  });
}

goHome(BuildContext context, String userGroup) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      if (userGroup == userGroupSyntax.professional) {
        return const ProHome();
      } else if (userGroup == userGroupSyntax.candidate) {
        return const CandidateHome();
      } else {
        return Text("unknown user group $userGroup");
      }
    }),
  );
}
