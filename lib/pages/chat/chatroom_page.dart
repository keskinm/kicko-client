import 'package:kicko/services/database.dart';
import 'package:kicko/pages/chat/theme.dart';

import 'package:kicko/services/app_state.dart';
import 'package:kicko/pages/chat/chat_page.dart';

import 'package:flutter/material.dart';
import 'package:kicko/shared/route.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<Map<String, dynamic>>? chatRoomsData;

  Widget chatRoomsList() {
    if (chatRoomsData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: chatRoomsData?.length ?? 0,
      itemBuilder: (context, index) {
        var chatRoom = chatRoomsData![index];
        return ChatRoomsTile(
          unReadMessages: chatRoom["unReadMessages"],
          userName: chatRoom['chatRoomId']
              .replaceAll('_', '')
              .replaceAll(appState.currentUser.username, ''),
          chatRoomId: chatRoom['chatRoomId'],
          setStates: onRebuild,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadChatRooms();
  }

  onRebuild() {
    // ------- ASYNC setSTates -------
    loadChatRooms();
  }

  void loadChatRooms() async {
    var chatsData =
        await DatabaseMethods().getUserChats(appState.currentUser.username);
    setState(() {
      chatRoomsData = chatsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatRoom"),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              // appState.authMethods.signOut();
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),

      // @todo have to make work this:
      body: Container(
        child: chatRoomsList(),
      ),

      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.search),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Search()));
      //   },
      // ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final int unReadMessages;
  final Function setStates;

  ChatRoomsTile(
      {required this.userName,
      required this.chatRoomId,
      required this.unReadMessages,
      required this.setStates});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushSetStateWhenBack(
            context,
            (context) => Chat(
                  chatRoomId: chatRoomId,
                ),
            setStates);
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
            Text("Unread: ${unReadMessages.toString()}")
          ],
        ),
      ),
    );
  }
}
