import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/logger.dart';

import 'dart:io';

abstract class FireBaseServiceInterface {
  addUserInfo(userData);
  getUserInfo(String email);
  searchByName(String searchField);
  Future<void> addChatRoom(chatRoom, chatRoomId);
  Future getChats(String chatRoomId);
  Future<void> addMessage(String chatRoomId, chatMessageData);
  getUserChats(String userName);
  Future<Map<String, dynamic>?> getLastMessage(String chatRoomId);
  Future<void> updateLastRead(
      String userName, String chatRoomId, int lastMessageTime);
  Future<bool> checkUserMessageNotifications(String userName);
  Future<String> downloadFile(String bucket, String fileId);
  downloadFiles(String bucket);
  Future<String> uploadFile(String bucket, String fileName, dynamic file);
  Future<String> uploadBytes(String bucket, String fileName, Uint8List bytes);
  Future<bool> deleteFireBaseStorageBucket(String bucket);
  bool deleteFireBaseStorageItem(String storageReference);
  Future deleteUserFromFireBase(String email, String password);
}

class FireBaseService implements FireBaseServiceInterface {
  FirebaseFirestore firestore;
  fs.FirebaseStorage firebaseStorage;

  FireBaseService({
    FirebaseFirestore? firestore,
    fs.FirebaseStorage? firebaseStorage,
  })  : this.firestore = firestore ?? FirebaseFirestore.instance,
        this.firebaseStorage = firebaseStorage ?? fs.FirebaseStorage.instance;

  // ------------------------CHAT FIREBASE--------------------------------------

  Future<void> addUserInfo(userData) async {
    firestore.collection("users").add(userData).catchError((e) {});
  }

  getUserInfo(String email) async {
    return firestore
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {});
  }

  searchByName(String searchField) {
    return firestore
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {});
  }

  Future getChats(String chatRoomId) async {
    return firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {});
  }

  getUserChats(String userName) async {
    // ----- CACHEABLE (SHARED ON SAME TREE WITH OTHER METHOD)----

    QuerySnapshot chatRoomSnapshot = await firestore
        .collection("chatRoom")
        .where('users', arrayContains: userName)
        .get();
    // ----- END CACHEABLE ----

    List<Map<String, dynamic>> chatRoomsWithUnreadNumber = [];
    for (var chatRoomDoc in chatRoomSnapshot.docs) {
      String chatRoomId = chatRoomDoc.id;
      var chatRoomDataMap = chatRoomDoc.data() as Map<String, dynamic>;
      dynamic lastRead = (chatRoomDataMap.containsKey('lastRead') &&
              chatRoomDataMap['lastRead'].containsKey(userName))
          ? chatRoomDataMap['lastRead'][userName]
          : null;

      QuerySnapshot allMessagesSnapshot = await firestore
          .collection("chatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .orderBy('time', descending: true)
          .get();

      int unReadMessages = 0;

      for (var messageDoc in allMessagesSnapshot.docs) {
        var data = messageDoc.data() as Map<String, dynamic>;

        if (data["time"] == lastRead) {
          break;
        } else if (data['sendBy'] != userName) {
          Logger.log(
              "senBy, ${data['sendBy']}, userName, ${userName}, lastRead, ${lastRead}, time, ${data['time']}, type last read, ${lastRead.runtimeType}, type time ${data['time'].runtimeType}",
              LogLevel.debug);

          unReadMessages++;
        }
      }

      chatRoomsWithUnreadNumber.add({
        'chatRoomId': chatRoomId,
        'unReadMessages': unReadMessages,
      });
    }

    return chatRoomsWithUnreadNumber;
  }

  Future<Map<String, dynamic>?> getLastMessage(String chatRoomId) async {
    QuerySnapshot snapshot = await firestore
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> updateLastRead(
      String userName, String chatRoomId, int lastMessageTime) async {
    return firestore.collection('chatRoom').doc(chatRoomId).update({
      'lastRead.$userName': lastMessageTime,
    });
  }

  @override
  Future<bool> checkUserMessageNotifications(String userName) async {
    // ----- CACHEABLE (SHARED ON SAME TREE WITH OTHER METHOD)----
    QuerySnapshot chatRoomSnapshot = await firestore
        .collection("chatRoom")
        .where('users', arrayContains: userName)
        .get();
    // ----- END CACHEABLE ----

    List<Map<String, dynamic>> chatRoomsWithLastMessage = [];
    for (var chatRoomDoc in chatRoomSnapshot.docs) {
      String chatRoomId = chatRoomDoc.id;

      QuerySnapshot allMessagesSnapshot = await firestore
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
        int? lastReadTime;
        if (dataMap.containsKey('lastRead') &&
            dataMap['lastRead'].containsKey(userName)) {
          lastReadTime = dataMap['lastRead'][userName];
        }

        chatRoomsWithLastMessage.add({
          'chatRoomId': chatRoomId,
          'lastMessage': lastMessageData,
          'lastRead': lastReadTime,
        });
      }
    }

    bool messagesNotification = false;
    for (var chat in chatRoomsWithLastMessage) {
      if (chat['lastRead'] == null ||
          chat["lastRead"] < chat['lastMessage']["time"]) {
        messagesNotification = true;
        break;
      }
    }

    return messagesNotification;
  }

  // ----------------------- FILES DATA STORE ------------------------------------------

  Future<String> downloadFile(String bucket, String fileId) async {
    fs.Reference ref = firebaseStorage.ref().child(bucket).child(fileId);

    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  dynamic downloadFiles(String bucket) async {
    fs.Reference ref = firebaseStorage.ref().child(bucket);

    final urls = await ref.listAll();
    dynamic refs = urls.items;
    dynamic res = [];
    for (dynamic ref in refs) {
      String link = await ref.getDownloadURL();
      res.add(link);
    }

    return res;
  }

  Future<String> uploadFile(
      String bucket, String fileName, dynamic file) async {
    String downloadURL;
    fs.Reference ref = firebaseStorage.ref().child(bucket).child(fileName);

    if (kIsWeb) {
      await ref.putData(await file);
    } else {
      await ref.putFile(File(file.path));
      // await ref.putFile(html.File(image.path.codeUnits, image.path));
    }

    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadBytes(
      String bucket, String fileName, Uint8List bytes) async {
    String downloadURL;
    fs.Reference ref = firebaseStorage.ref().child(bucket).child(fileName);
    await ref.putData(bytes);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<bool> deleteFireBaseStorageBucket(String bucket) async {
    fs.Reference toDeleteBucket = firebaseStorage.ref().child(bucket);
    final urls = await toDeleteBucket.listAll();
    dynamic refs = urls.items;
    for (dynamic ref in refs) {
      firebaseStorage.ref(ref.fullPath).delete();
    }

    return true;
  }

  bool deleteFireBaseStorageItem(String storageReference) {
    fs.Reference storageReferenceBase = firebaseStorage.ref();

    bool success = false;

    storageReferenceBase.child(storageReference).delete().then((_) {
      success = true;
    });

    return success;
  }

  Future deleteUserFromFireBase(String email, String password) async {
    try {
      UserCredential firebaseUser = await appState.authMethods.fAuth
          .signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.user!.delete();
      await appState.authMethods.fAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Logger.log(
            'The user must reauthenticate before this operation can be executed.',
            LogLevel.warning);
      }
    }
  }
}
