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

Future<List<Map<String, dynamic>>> _getUserChats(String itIsMyName) async {
  QuerySnapshot chatRoomSnapshot = await FirebaseFirestore.instance
      .collection("chatRoom")
      .where('users', arrayContains: itIsMyName)
      .get();

  List<Map<String, dynamic>> chatRoomsWithLastMessage = [];
  for (var chatRoomDoc in chatRoomSnapshot.docs) {
    String chatRoomId = chatRoomDoc.id;
    
    QuerySnapshot lastMessageSnapshot = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    if (lastMessageSnapshot.docs.isNotEmpty) {
      var lastMessageData = lastMessageSnapshot.docs.first.data();
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
              print("NOT CONTAINING");
              isUpToDate = "NEW MESSAGE";
            } else {
              print("CONTAINING");
              dynamic lastRead = chat["lastRead"];
              dynamic lastMessage = chat['lastMessage']["time"];

              if (lastRead < lastMessage) {
                isUpToDate = "NEW MESSAGE";
                print("BUT INFERIOR");
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
