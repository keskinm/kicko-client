import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatelessWidget {
  final String chatroomId;
  final String otherUserUsername;

  const ChatPage(
      {Key? key, required this.chatroomId, required this.otherUserUsername})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserUsername),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats/$chatroomId/messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(message['text']),
                        subtitle: Text(message['senderId']),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        InputDecoration(labelText: 'Envoyer un message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (messageController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('chats/$chatroomId/messages')
                          .add({
                        'text': messageController.text,
                        'senderId': FirebaseAuth.instance.currentUser!.uid,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
