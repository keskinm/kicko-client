import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/pages/chat/chat_page.dart';
import 'package:kicko/services/database.dart';
import 'package:kicko/to_move/chat_page.dart';

void openChat(BuildContext context, Map<String, dynamic> otherUser) {
  print("ici");
  print(appState.currentUser.id);
  print(appState.currentUser.username);
  String chatroomId =
      generateChatroomId(appState.currentUser.id, otherUser['id']);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatPage(
        chatroomId: chatroomId,
        otherUserUsername: otherUser['username'],
      ),
    ),
  );
}

String generateChatroomId(String userId, String otherUserId) {
  return '$userId-$otherUserId';
}

void openChatBis(BuildContext context, Map<String, dynamic> user) {
  // Utilisez le nom d'utilisateur pour envoyer un message à cette personne
  sendMessage(user['username'], context);
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

sendMessage(String userName, BuildContext context) {
  List<String> users = [appState.currentUser.username, userName];

  String chatRoomId = getChatRoomId(appState.currentUser.username, userName);

  Map<String, dynamic> chatRoom = {
    "users": users,
    "chatRoomId": chatRoomId,
  };

  DatabaseMethods databaseMethods = new DatabaseMethods();
  databaseMethods.addChatRoom(chatRoom, chatRoomId);

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Chat(
                chatRoomId: chatRoomId,
              )));
}
