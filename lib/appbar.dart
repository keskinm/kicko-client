import 'package:flutter/material.dart';
import 'package:kicko/user/ui/my_account.dart';

AppBar simpleAppBar([String? text]) {
  return AppBar(
      // backgroundColor: Colors.white,
      // No need backgroundColor because done in ThemData of MaterialApp.
      title: text != null ? Center(child: Text(text)) : null);
}

AppBar userAppBar(String text, BuildContext pageContext) {
  return AppBar(
    title: Text(text),
    centerTitle: true,
    actions: [
      PopupMenuButton(itemBuilder: (context) {
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
      }, onSelected: (value) {
        if (value == 0) {
          Navigator.push(pageContext, MaterialPageRoute(builder: (context) {
            return const MyAccount();
          }));
        } else if (value == 1) {
        } else if (value == 2) {}
      }),
    ],
  );
}
