import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/settings/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

class StudyLobbyDetails extends StatefulWidget {
  final String uid;
  final DocumentSnapshot groupDetails;

  StudyLobbyDetails({this.uid, this.groupDetails});

  @override
  _StudyLobbyDetails createState() =>
      _StudyLobbyDetails(uid: uid, groupDetails: groupDetails);
}

class _StudyLobbyDetails extends State<StudyLobbyDetails> {
  final String uid;
  final DocumentSnapshot groupDetails;

  _StudyLobbyDetails({this.uid, this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RetrieveUserInfo(uid: uid)
            .retrieveInBulk(List.from(groupDetails.data()['members'])),
        builder: (BuildContext context, AsyncSnapshot usrDetails) {
          if (usrDetails.hasData) {
            return Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Created By: ${usrDetails.data[0].data()["name"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            "Description: ${groupDetails.data()["description"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            "Modules: ${groupDetails.data()["modules"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            "Telegram Group Link: ${groupDetails.data()["telegram_group"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          Text("Members: ",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    ListView.builder(
                      itemCount: usrDetails.data.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: ProfilePic(
                                  uid: List.from(
                                      groupDetails.data()['members'])[index],
                                  upSize: false,
                                  rep: usrDetails.data[index].data()["rep"],
                                ),
                                title: Text(
                                  '${usrDetails.data[index].data()["name"]}',
                                  style: TextStyle(fontSize: 24),
                                ),
                                subtitle: Text((index == 0) ? "Creator" : ""),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await StudyLobbyDatabase(uid: uid).addMember(groupDetails.id);
                  Navigator.of(context).pop();
                },
                tooltip: "Join Group",
                child: Icon(Icons.group_add),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
