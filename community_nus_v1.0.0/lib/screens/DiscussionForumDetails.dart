import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/screens/CreateReplyForum.dart';
import 'package:community_nus/screens/createDiscussionThread.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:flutter/material.dart';

class ForumDetails extends StatefulWidget {
  final String uid;
  final String title;
  final String moduleCode;

  ForumDetails({this.uid, this.title, this.moduleCode});

  @override
  _ForumDetails createState() =>
      _ForumDetails(uid: uid, title: title, moduleCode: moduleCode);
}

class _ForumDetails extends State<ForumDetails> {
  final String uid;
  final String title;
  final String moduleCode;

  _ForumDetails({this.uid, this.title, this.moduleCode});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ForumRepliesDataBase(uid: uid).retrieveForumReplies(),
        builder: (BuildContext context, AsyncSnapshot forumReplies) {
          if (forumReplies.hasData) {
            return FutureBuilder(
                future: ForumRepliesDataBase(uid: uid).retrieveUser(),
                builder: (BuildContext context, AsyncSnapshot userDetails) {
                  List<QueryDocumentSnapshot> listData = userDetails.data;
                  int userIdx = 0;
                  for (int i = 0; i < listData.length; i++) {
                    if (listData[i].id.toString().compareTo(this.uid) == 0) {
                      userIdx = i;
                    }
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
                        title: Text(moduleCode + " " + title),
                        titleTextStyle: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                        elevation: 0.0,
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                //Need change to create reply
                                return CreateReplyForum(uid: uid);
                              },
                            ),
                          );
                        },
                        tooltip: "Reply",
                        child: const Icon(Icons.reply),
                      ),
                      body: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5.0, 10),
                        child: ListView(
                          children: <Widget>[
                            SizedBox(height: 25),

                            //The list below
                            ListView.separated(
                              itemCount: forumReplies.data.length,
                              shrinkWrap: true,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              // itemCount:
                              //     disussionForum == null ? 0 : disussionForum.length,
                              // itemBuilder: (BuildContext context, int index) {
                              //   Map thread = disussionForum[index];
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Wrap(
                                      direction: Axis.vertical,
                                      alignment: WrapAlignment.center,
                                      children: <Widget>[
                                        ClipOval(
                                          child: Material(
                                            color: Colors.white, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.green, // inkwell color
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              ),
                                              onTap: () async {
                                                await DiscussionForumDatabase(
                                                        uid: uid)
                                                    .updateUpvote(
                                                        "${forumReplies.data[index].data()["replies"].toString()}",
                                                        int.parse(
                                                            "${forumReplies.data[index].data()["upvote"].toString()}"));
                                                // Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        Text(
                                          (int.parse("${forumReplies.data[index].data()["upvote"].toString()}") -
                                                  int.parse(
                                                      "${forumReplies.data[index].data()["downvote"].toString()}"))
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        ClipOval(
                                          child: Material(
                                            color: Colors.white, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.red, // inkwell color
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                              onTap: () async {
                                                await DiscussionForumDatabase(
                                                        uid: uid)
                                                    .updateDownvote(
                                                        "${forumReplies.data[index].data()["replies"].toString()}",
                                                        int.parse(
                                                            "${forumReplies.data[index].data()["downvote"].toString()}"));
                                                // Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ]),
                                  title: RichText(
                                    text: TextSpan(
                                      text:
                                          "${forumReplies.data[index].data()["replies"].toString()}",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "\nPosted by " +
                                            "${userDetails.data[userIdx].data()["name"].toString()}" +
                                            " on ${forumReplies.data[index].data()["dateAndTime"].toString()}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ));
                });
          }
          return CircularProgressIndicator();
        });
  }
}