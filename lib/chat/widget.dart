import 'package:flutter/material.dart';
import 'package:kicko/chat/ui/chatroom_page.dart';
import 'package:kicko/shared/route.dart';

PreferredSizeWidget? appBarMain(BuildContext context) {
  return AppBar(
    title: Text(""),
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

Widget buildGoChatButton(
    BuildContext context, bool? messagesNotification, Function setStates) {
  return messagesNotification == null
      ? CircularProgressIndicator()
      : GestureDetector(
          onTap: () =>
              pushSetStateWhenBack(context, (context) => ChatRoom(), setStates),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.message, size: 50.0),
              if (messagesNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
}

Widget buildGoChatRoomButton(
    BuildContext context, bool? messagesNotification, Function setStates) {
  return messagesNotification == null
      ? CircularProgressIndicator()
      : GestureDetector(
          onTap: () =>
              pushSetStateWhenBack(context, (context) => ChatRoom(), setStates),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.message, size: 50.0),
              if (messagesNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
}

List<Widget> chatWidgetsList(
    BuildContext context, bool? messagesNotification, dynamic widget) {
  return [
    Expanded(
        child: buildGoChatRoomButton(
            context, messagesNotification, widget.onRebuild)),
  ];
}
