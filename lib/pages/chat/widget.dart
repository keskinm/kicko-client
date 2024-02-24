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

Future<bool> checkUserMessageNotifications(String userName) async {
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

  bool isUpToDate = true;
  for (var chat in chatRoomsWithLastMessage) {
    if (!chat.containsKey('lastRead') ||
        chat["lastRead"] < chat['lastMessage']["time"]) {
      isUpToDate = false;
      break;
    }
  }

  return isUpToDate;
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
