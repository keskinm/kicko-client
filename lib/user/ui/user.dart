import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:kicko/services/network_image.dart';

mixin UserStateMixin<T extends StatefulWidget> on State<T> {
  late String userName;
  bool? messagesNotification;
  FireBaseServiceInterface? databaseMethods;
  late Future<String> userImageUrl;

  onRebuild() {
    // ------- ASYNC setSTates -------
    updateMessagesNotification();
    setState(() {
      userImageUrl =
          Provider.of<FireBaseServiceInterface>(context, listen: false)
              .downloadFile('default', 'ca_default_profile.jpg');
    });
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

  avatarFutureBuilder() {
    return FutureBuilder<dynamic>(
        future: userImageUrl,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          Widget failingBody;
          if (snapshot.hasData) {
            return CustomCircleAvatar(
              imageUrl: snapshot.data!,
              imageService: Provider.of<ImageNetworkServiceInterface>(context,
                  listen: false),
            );
          } else if (snapshot.hasError) {
            failingBody = Text('Error: ${snapshot.error}');
          } else {
            failingBody = const CircularProgressIndicator(
              color: Colors.orangeAccent,
            );
          }
          return Scaffold(body: failingBody);
        });
  }
}
