import 'package:flutter/material.dart';
import 'package:kicko/user/ui/account.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/shared/route.dart';

AppBar simpleAppBar(BuildContext context,
    {String? text, bool allowGoHome = true}) {
  List<Widget> rowChildren = [];

  if (Navigator.canPop(context)) {
    rowChildren.add(Flexible(
        child: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    )));
  }

  if (allowGoHome) {
    // INSTEAD OF THIS, USE
    // Navigator.popUntil(context, ModalRoute.withName('/candidate_home'));
    // AFTER DEFINING ROUTES IN MATERIAL APP (ONE CAN ALSO USE DYNAMIC ROUTING
    // WITH onGenerateRoute: (settings))
    rowChildren.add(Flexible(
        child: IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        popUntilHome(context, appState.userGroup);
      },
    )));
  }

  return AppBar(
    title: text != null ? Center(child: Text(text)) : null,
    leading: Row(mainAxisSize: MainAxisSize.min, children: rowChildren),
  );
}

AppBar userAppBar(String text, BuildContext pageContext,
    {dynamic avatarBuilder = null}) {
  return AppBar(
    title: Text(text),
    centerTitle: true,
    actions: [
      PopupMenuButton(
          icon: Container(
            child: (avatarBuilder == null) ? Icon(Icons.person) : avatarBuilder,
            width: kToolbarHeight,
            height: kToolbarHeight,
          ),
          itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Mon compte"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Mes paramètres"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Se déconnecter"),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 0) {
              Navigator.push(pageContext, MaterialPageRoute(builder: (context) {
                return const Account();
              }));
            } else if (value == 1) {
            } else if (value == 2) {}
          }),
    ],
  );
}
