import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/pages/chat/chat_page.dart';
import 'package:kicko/services/database.dart';
import 'package:provider/provider.dart';

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

sendMessage(BuildContext context, String userName) {
  List<String> users = [appState.currentUser.username, userName];

  String chatRoomId = getChatRoomId(appState.currentUser.username, userName);

  Map<String, dynamic> chatRoom = {
    "users": users,
    "chatRoomId": chatRoomId,
  };

  Provider.of<FireBaseServiceInterface>(context, listen: false)
      .addChatRoom(chatRoom, chatRoomId);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Chat(
                chatRoomId: chatRoomId,
              )));
}
