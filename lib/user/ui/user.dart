import 'package:flutter/material.dart';
import 'package:kicko/services/app_state.dart';
import 'package:kicko/services/firebase.dart';
import 'package:provider/provider.dart';
import 'package:kicko/user/domain/medias_domain.dart';
import 'package:kicko/end_point.dart';

mixin UserStateMixin<T extends StatefulWidget> on State<T> {
  late String userName;
  late String imagesBucket;
  late String profileUrl;
  bool? messagesNotification;
  FireBaseServiceInterface? databaseMethods;
  late Future<String> userImageUrl;
  late Future<Map<String, dynamic>> profile;

  onRebuild() {
    // ------- ASYNC setSTates -------
    updateMessagesNotification();
    setState(() {
      profile = getRequest(profileUrl, [appState.currentUser.id]);
      userImageUrl = getProfileImage(profile, imagesBucket, context);
    });
  }

  @override
  void initState() {
    super.initState();
    databaseMethods =
        Provider.of<FireBaseServiceInterface>(context, listen: false);
    userName = appState.currentUser.username;
    imagesBucket = '${appState.userGroup}/${userName}/profile_images';
    profileUrl = "${appState.userGroup}_get_profile";
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
