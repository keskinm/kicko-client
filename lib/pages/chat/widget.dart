import 'package:flutter/material.dart';
import 'package:kicko/pages/chat/search_page.dart';
import 'package:kicko/pages/chat/chatroom_page.dart';
import 'package:kicko/services/database.dart';

DatabaseMethods dataBaseMethods = DatabaseMethods();

PreferredSizeWidget? appBarMain(BuildContext context) {
  return AppBar(
    title: Text("????"),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

List<Widget> chatWidgetsList(
    BuildContext context, bool? messagesNotification, dynamic widget) {
  return [
    messagesNotification == null
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatRoom()),
              ).then((_) {
                widget.onReBuild();
              });
            },
            child: Text(messagesNotification ? "Up To Date" : "New Message")),
    TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Search()),
          );
        },
        child: const Text("SEARCH")),
  ];
}
