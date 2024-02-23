import 'package:flutter/material.dart';
import 'package:kicko/pages/chat/search_page.dart';
import 'package:kicko/pages/chat/chatroom_page.dart';

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

List<Widget> chatWidgetsList(BuildContext context) {
  return [
    TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatRoom()),
          );
        },
        child: const Text("CHAT ROOM")),
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
