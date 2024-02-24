import 'package:flutter/material.dart';
import 'package:kicko/pages/chat/search_page.dart';
import 'package:kicko/pages/chat/chatroom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kicko/services/database.dart';
import 'package:kicko/services/app_state.dart';

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

Future<List<Map<String, dynamic>>> _getUserChats(String userName) async {
  QuerySnapshot chatRoomSnapshot = await FirebaseFirestore.instance
      .collection("chatRoom")
      .where('users', arrayContains: userName)
      .get();

  List<Map<String, dynamic>> chatRoomsWithLastMessage = [];
  for (var chatRoomDoc in chatRoomSnapshot.docs) {
    String chatRoomId = chatRoomDoc.id;

    QuerySnapshot allMessagesSnapshot = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .get();

    Map<String, dynamic>? lastMessageData;
    for (var messageDoc in allMessagesSnapshot.docs) {
      var data = messageDoc.data() as Map<String, dynamic>;
      if (data['sendBy'] != userName) {
        lastMessageData = data;
        break;
      }
    }

    if (lastMessageData != null) {
      var dataMap = chatRoomDoc.data() as Map<String, dynamic>;
      chatRoomsWithLastMessage.add({
        'chatRoomId': chatRoomId,
        'lastMessage': lastMessageData,
        'lastRead': dataMap['lastRead'],
      });
    }
  }

  return chatRoomsWithLastMessage;
}

List<Widget> chatWidgetsList(BuildContext context) {
  return [
    FutureBuilder<List<Map<String, dynamic>>>(
      future: _getUserChats(appState.currentUser.username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Map<String, dynamic>> userChats = snapshot.data!;

          String isUpToDate = "UpToDate";

          for (var chat in userChats) {
            if (!chat.containsKey('lastRead')) {
              isUpToDate = "NEW MESSAGE";
            } else {
              dynamic lastRead = chat["lastRead"];
              dynamic lastMessage = chat['lastMessage']["time"];

              if (lastRead < lastMessage) {
                isUpToDate = "NEW MESSAGE";
              }
            }
          }

          return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatRoom()),
                );
              },
              child: new Text(isUpToDate));
        } else {
          return CircularProgressIndicator();
        }
      },
    ),
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
