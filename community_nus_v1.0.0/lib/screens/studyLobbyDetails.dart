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

  bool joined = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            StudyLobbyDatabase(uid: uid).retrieveDetailsForGroup(groupDetails),
        builder: (BuildContext context, AsyncSnapshot details) {
          if (details.hasData) {
            return FutureBuilder(
                future: RetrieveUserInfo(uid: uid)
                    .retrieveInBulk(List.from(details.data.data()['members'])),
                builder: (BuildContext context, AsyncSnapshot usrDetails) {
                  if (usrDetails.hasData) {
                    for (int i = 0; i < usrDetails.data.length; i++) {
                      if (List.from(details.data.data()['members'])[i] == uid)
                        joined = true;
                    }
                    return Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                          icon: Icon(Icons.keyboard_backspace),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        centerTitle: true,
                        title: Text("${groupDetails.data()["group_name"]}"),
                        elevation: 0.0,
                      ),
                      body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "Creator",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                usrDetails.data[0].data()["name"],
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                details.data.data()["description"],
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Modules",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                groupDetails.data()["modules"],
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Telegram Invite Link",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                joined
                                    ? details.data.data()["telegram_group"]
                                    : "Join to view",
                                style: joined
                                    ? TextStyle(fontSize: 17)
                                    : TextStyle(
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic),
                              ),
                            ),
                            Container(height: 10.0),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                              child: Text(
                                "Members".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                          uid: List.from(details.data
                                              .data()['members'])[index],
                                          upSize: false,
                                          rep: usrDetails.data[index]
                                              .data()["rep"],
                                        ),
                                        title: Text(
                                          '${usrDetails.data[index].data()["name"]}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        subtitle: Text(
                                            '${usrDetails.data[index].data()["faculty"]}'),
                                        trailing:
                                            Text((index == 0) ? "Creator" : ""),
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
                          await StudyLobbyDatabase(uid: uid)
                              .addMember(groupDetails);
                          //Navigator.of(context).pop();
                          setState(() {});
                        },
                        tooltip: "Join Group",
                        child: Icon(Icons.group_add),
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                });
          }
          return CircularProgressIndicator();
        });
  }
}
