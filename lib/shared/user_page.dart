import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/database.dart';

DatabaseMethods databaseMethods = DatabaseMethods();

mixin UserStateMixin<T extends StatefulWidget> on State<T> {
  late String userName;
  bool? messagesNotification;

  onRebuild() {
    // ------- ASYNC setSTates -------
    updateMessagesNotification();
  }

  @override
  void initState() {
    super.initState();
    userName = appState.currentUser.username;
    onRebuild();
  }

  Future<void> updateMessagesNotification() async {
    bool isUpToDate =
        await databaseMethods.checkUserMessageNotifications(userName);
    setState(() {
      messagesNotification = isUpToDate;
    });
  }
}
