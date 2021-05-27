import 'package:community_nus/settings/conversationList.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/ChatUsers.dart';
import 'package:community_nus/screens/createStudyLobby.dart';
import 'package:community_nus/screens/studyLobbyDetails.dart';
import 'package:community_nus/settings/search.dart';

/* Users need to reload this page to re-fetch data after joining a study group
* to view changes to the members list.
* UI needs to be improved.
* Any other additional functionalities of study lobby??
* */

class StudyLobby extends StatefulWidget {
  final String uid;

  StudyLobby({this.uid});

  @override
  _StudyLobbyState createState() => _StudyLobbyState(uid: uid);
}

class _StudyLobbyState extends State<StudyLobby> {
  final String uid;

  _StudyLobbyState({this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StudyLobbyDatabase(uid: uid).retrieveAll(),
        builder: (BuildContext context, AsyncSnapshot lobby) {
          if (lobby.hasData) {
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
                              "Study Lobby",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                icon: Icon(Icons.search),
                                tooltip: "Search a module code",
                                onPressed: () async {
                                  final result = await showSearch(
                                      context: context,
                                      delegate:
                                          ModuleSearch(lobby: lobby.data));
                                  if (result != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return StudyLobbyDetails(
                                              uid: uid, groupDetails: result);
                                        },
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    /*Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search a study group...",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade100)),
                        ),
                      ),
                    ),*/
                    /*ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),*/
                    ListView.builder(
                      itemCount: lobby.data.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Column(
                                  children: <Widget>[
                                    Icon(Icons.group),
                                    Text(
                                        '${lobby.data[index].data()["strength"].toString()}/20'),
                                  ],
                                ),
                                title: Text(
                                  '${lobby.data[index].data()["group_name"]}',
                                  style: TextStyle(fontSize: 24),
                                ),
                                subtitle: Text(
                                  '${lobby.data[index].data()["modules"]}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return StudyLobbyDetails(
                                                  uid: uid,
                                                  groupDetails:
                                                      lobby.data[index]);
                                            },
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Text('VIEW DETAILS')),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return CreateStudyLobby(uid: uid);
                      },
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                tooltip: "Create A Study Group",
                child: const Icon(Icons.add),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

/*List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Instagram Group",
        messageText: "Awesome Setup",
        imageURL: "images/instagram.png",
        time: "Now"),
    ChatUsers(
        name: "XMM Group",
        messageText: "That's Great",
        imageURL: "images/tiktok.png",
        time: "Yesterday"),
    ChatUsers(
        name: "Facebook Group",
        messageText: "Hey where are you?",
        imageURL: "images/facebook.png",
        time: "31 Mar"),
  ];*/
}
