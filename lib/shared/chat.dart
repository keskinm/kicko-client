import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/pages/chat/chat_page.dart';


void openChat(BuildContext context, Map<String, dynamic> otherUser) {
  print("ici");
  print(appState.currentUser.id);
  print(appState.currentUser.username);
  String chatroomId = generateChatroomId(appState.currentUser.id, otherUser['id']);

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
