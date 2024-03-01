import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/firebase.dart';
import 'package:provider/provider.dart';

mixin UserStateMixin<T extends StatefulWidget> on State<T> {
  late String userName;
  bool? messagesNotification;
  FireBaseServiceInterface? databaseMethods;

  onRebuild() {
    // ------- ASYNC setSTates -------
    updateMessagesNotification();
  }

  @override
  void initState() {
    super.initState();
    databaseMethods =
        Provider.of<FireBaseServiceInterface>(context, listen: false);
    userName = appState.currentUser.username;
    onRebuild();
  }

  Future<void> updateMessagesNotification() async {
    bool _messagesNotification =
        await databaseMethods!.checkUserMessageNotifications(userName);
    setState(() {
      messagesNotification = _messagesNotification;
    });
  }
}
