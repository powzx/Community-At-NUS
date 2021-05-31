import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/screens/CreateReplyForum.dart';
import 'package:community_nus/screens/createDiscussionThread.dart';
import 'package:community_nus/screens/notifications.dart';
import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/profile_pic.dart';

class ForumDetails extends StatefulWidget {
  final String uid;
  final String creator_uid;
  final String title;
  final String moduleCode;
  final String threads;

  ForumDetails(
      {this.uid, this.creator_uid, this.title, this.moduleCode, this.threads});

  @override
  _ForumDetails createState() => _ForumDetails(
      uid: uid,
      creator_uid: creator_uid,
      title: title,
      moduleCode: moduleCode,
      threads: threads);
}

class _ForumDetails extends State<ForumDetails> {
  final String uid;
  final String creator_uid;
  final String title;
  final String moduleCode;
  final String threads;

  _ForumDetails(
      {this.uid, this.creator_uid, this.title, this.moduleCode, this.threads});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ForumRepliesDataBase(uid: uid).retrieveForumReplies(title),
        builder: (BuildContext context, AsyncSnapshot forumReplies) {
          if (forumReplies.hasData) {
            return FutureBuilder(
                future: UserDatabase(uid: uid).retrieveUser(),
                builder: (BuildContext context, AsyncSnapshot userDetails) {
                  if (userDetails.hasData) {
                    return Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          leading: IconButton(
                            icon: Icon(Icons.keyboard_backspace),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          title: Text(
                            Constants.appName,
                          ),
                          elevation: 0.0,
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {});
                              },
                              tooltip: "Refresh",
                            ),
                            IconButton(
                              icon: IconBadge(
                                icon: Icons.notifications,
                                size: 22.0,
                                uid: uid,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return Notifications(uid: uid);
                                    },
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              tooltip: "Notifications",
                            ),
                            SizedBox(height: 45),
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  //Need change to create reply
                                  return CreateReplyForum(
                                      uid: uid,
                                      creator_uid: creator_uid,
                                      title: title,
                                      moduleCode: moduleCode);
                                },
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          tooltip: "Reply",
                          child: const Icon(Icons.reply),
                        ),
                        body: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5.0, 5),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(6, 6, 6.0, 2),
                                child: Text(
                                  moduleCode + " " + title,
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),

                              Padding(
                                padding: EdgeInsets.fromLTRB(6, 0, 10.0, 6),
                                child: Text(
                                  threads,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),

                              //The list below
                              ListView.separated(
                                itemCount: forumReplies.data.length,
                                shrinkWrap: true,
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: ProfilePic(
                                        uid: forumReplies.data[index]
                                            .data()["thread_uid"],
                                        upSize: false,
                                        rep: userDetails.data[getUserIdx(
                                                "${forumReplies.data[index].data()["thread_uid"].toString()}",
                                                userDetails)]
                                            .data()["rep"]),
                                    trailing: Wrap(
                                        direction: Axis.vertical,
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          ClipOval(
                                            child: Material(
                                              color:
                                                  Colors.white, // button color
                                              child: InkWell(
                                                splashColor: Colors
                                                    .green, // inkwell color
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
                                                  await ForumRepliesDataBase(
                                                          uid: uid)
                                                      .updateUpvote(
                                                          "${forumReplies.data[index].data()["replies"].toString()}",
                                                          int.parse(
                                                              "${forumReplies.data[index].data()["upvote"].toString()}"));
                                                  await UserDatabase(
                                                          uid: forumReplies
                                                                  .data[index]
                                                                  .data()[
                                                              "thread_uid"])
                                                      .increaseRep();
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
                                              color:
                                                  Colors.white, // button color
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
                                                  await ForumRepliesDataBase(
                                                          uid: uid)
                                                      .updateDownvote(
                                                          "${forumReplies.data[index].data()["replies"].toString()}",
                                                          int.parse(
                                                              "${forumReplies.data[index].data()["downvote"].toString()}"));
                                                  await UserDatabase(
                                                          uid: forumReplies
                                                                  .data[index]
                                                                  .data()[
                                                              "thread_uid"])
                                                      .decreaseRep();
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
                                              "${userDetails.data[getUserIdx("${forumReplies.data[index].data()["thread_uid"].toString()}", userDetails)].data()["name"].toString()}" +
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
                  }
                  return CircularProgressIndicator();
                });
          }
          return CircularProgressIndicator();
        });
  }
}

int getUserIdx(String currPostIDX, AsyncSnapshot userDetails) {
  int userIdx = 0;
  if (userDetails.hasData) {
    for (int i = 0; i < userDetails.data.length; i++) {
      if (userDetails.data[i].id.toString().compareTo(currPostIDX) == 0) {
        userIdx = i;
      }
    }
  }
  return userIdx;
}
