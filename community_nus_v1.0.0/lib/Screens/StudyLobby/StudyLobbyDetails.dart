import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/Screens/StudyLobby/EditStudyLobby.dart';
import 'package:community_nus/Settings_BackEndDataBase/profile_pic.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/material.dart';

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
                              trailing: (details.data.data()['members'][0] ==
                                      uid)
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20.0,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return EditStudyGroup(
                                            uid: uid,
                                            groupDetails: groupDetails,
                                            originalDesc: details.data
                                                .data()['description'],
                                            originalTele: details.data
                                                .data()['telegram_group'],
                                            originalAnnounce: details.data
                                                .data()['announcement'],
                                            originalHideout:
                                                details.data.data()['hideout'],
                                            members: List.from(
                                                details.data.data()['members']),
                                          );
                                        })).then((value) {
                                          setState(() {});
                                        });
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20.0,
                                      ),
                                      onPressed: () {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                    "You do not have administrative rights to perform this action"),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'))
                                                ],
                                              );
                                            });
                                      }),
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
                            ListTile(
                              title: Text(
                                "Announcement",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                joined
                                    ? details.data.data()['announcement']
                                    : "Join to view",
                                style: joined
                                    ? TextStyle(fontSize: 17)
                                    : TextStyle(
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Study Hideout",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                joined
                                    ? details.data.data()['hideout']
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
                          if (!joined) {
                            await StudyLobbyDatabase(uid: uid)
                                .addMember(groupDetails);
                            await NotificationsDatabase(
                                    uid: groupDetails.data()['host_uid'])
                                .sendData(
                                    0,
                                    uid,
                                    groupDetails.data()['group_name'],
                                    DateTime.now());
                            //Navigator.of(context).pop();
                            setState(() {});
                          } else {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content:
                                        Text("You are already in the group."),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'))
                                    ],
                                  );
                                });
                          }
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
