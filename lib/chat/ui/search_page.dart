import 'package:kicko/chat/theme.dart';
import 'package:kicko/services/firebase.dart';
import 'package:kicko/chat/widget.dart';
import 'package:kicko/shared/domain/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchEditingController = new TextEditingController();
  late QuerySnapshot searchResultSnapshot;

  String title = 'Recherche utilisateur';
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FireBaseServiceInterface>(context, listen: false)
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;

        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.docs[index]["userName"],
                searchResultSnapshot.docs[index]["userEmail"],
              );
            })
        : Container();
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(color: Colors.black12, fontSize: 16),
              ),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.black12, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(context, userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: const Text(
                'Message',
                style: TextStyle(color: Colors.black12, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: CustomTheme.colorAccent,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: simpleTextStyle(),
                            decoration: const InputDecoration(
                                hintText: 'search username ...',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0x36FFFFFF),
                                        Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Text("search")),
                        )
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
