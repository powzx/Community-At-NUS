import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

class StudyLobbyDetails extends StatefulWidget {
  final String uid;
  final DocumentSnapshot groupDetails;

  StudyLobbyDetails({this.uid, this.groupDetails});

  @override
  _StudyLobbyDetails createState() => _StudyLobbyDetails(uid: uid, groupDetails: groupDetails);
}

class _StudyLobbyDetails extends State<StudyLobbyDetails> {
  final String uid;
  final DocumentSnapshot groupDetails;

  _StudyLobbyDetails({this.uid, this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${groupDetails.data()["group_name"]}",
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Created By: ${groupDetails.data()["host_uid"]}"),
                  Text("Description: ${groupDetails.data()["description"]}"),
                  Text("Modules: ${groupDetails.data()["modules"]}"),
                  Text("Telegram Group Link: ${groupDetails.data()["telegram_group"]}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}