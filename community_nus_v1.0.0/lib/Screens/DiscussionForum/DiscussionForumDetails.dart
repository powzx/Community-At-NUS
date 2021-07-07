import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/Screens/BaseScreen_Feature/Notifications.dart';
import 'package:community_nus/Screens/DiscussionForum/CreateReplyForum.dart';
import 'package:community_nus/Settings_BackEndDataBase/Badge.dart';
import 'package:community_nus/Settings_BackEndDataBase/Constant.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/Settings_BackEndDataBase/Profile_pic.dart';

class ForumDetails extends StatefulWidget {
  final String uid;
  final String creator_uid;
  final String title;
  final String moduleCode;
  final String threads;
  final String dateOfCreation;

  ForumDetails(
      {this.uid,
      this.creator_uid,
      this.title,
      this.moduleCode,
      this.threads,
      this.dateOfCreation});

  @override
  _ForumDetails createState() => _ForumDetails(
      uid: uid,
      creator_uid: creator_uid,
      title: title,
      moduleCode: moduleCode,
      threads: threads,
      dateOfCreation: dateOfCreation);
}

class _ForumDetails extends State<ForumDetails> {
  final String uid;
  final String creator_uid;
  final String title;
  final String moduleCode;
  final String threads;
  final String dateOfCreation;

  _ForumDetails(
      {this.uid,
      this.creator_uid,
      this.title,
      this.moduleCode,
      this.threads,
      this.dateOfCreation});

  String dropDownValue = "Most Recent";

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
                    List<DocumentSnapshot> sortedReplies =
                        sortByPopularity(forumReplies);
                    List<DocumentSnapshot> displayReplies;
                    if (dropDownValue == "Most Recent") {
                      displayReplies = forumReplies.data;
                    } else {
                      displayReplies = sortedReplies;
                    }

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
                              SizedBox(height: 5),

                              Padding(
                                padding: EdgeInsets.fromLTRB(6, 0, 10.0, 6),
                                child: Text(
                                  "Posted by " +
                                      "${userDetails.data[getUserIdx(creator_uid, userDetails)].data()["name"].toString()}" +
                                      " on $dateOfCreation",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              Padding(
                                padding: EdgeInsets.fromLTRB(6, 0, 10.0, 6),
                                child: DropdownButton(
                                  value: dropDownValue,
                                  //style: TextStyle(fontSize: 15),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropDownValue = newValue;
                                    });
                                  },
                                  elevation: 16,
                                  items: <String>["Most Recent", "Most Popular"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 5),
                              //The list below
                              ListView.separated(
                                itemCount: displayReplies.length,
                                shrinkWrap: true,
                                primary: false,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: ProfilePic(
                                        key: UniqueKey(),
                                        uid: displayReplies[index]
                                            .data()["thread_uid"],
                                        upSize: false,
                                        rep: userDetails.data[getUserIdx(
                                                "${displayReplies[index].data()["thread_uid"].toString()}",
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
                                                          "${displayReplies[index].id}",
                                                          int.parse(
                                                              "${displayReplies[index].data()["upvote"].toString()}"));
                                                  await UserDatabase(
                                                          uid: displayReplies[
                                                                      index]
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
                                            (int.parse("${displayReplies[index].data()["upvote"].toString()}") -
                                                    int.parse(
                                                        "${displayReplies[index].data()["downvote"].toString()}"))
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
                                                          "${displayReplies[index].id}",
                                                          int.parse(
                                                              "${displayReplies[index].data()["downvote"].toString()}"));
                                                  await UserDatabase(
                                                          uid: displayReplies[
                                                                      index]
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
                                            "${displayReplies[index].data()["replies"].toString()}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          "\nPosted by " +
                                              "${userDetails.data[getUserIdx("${displayReplies[index].data()["thread_uid"].toString()}", userDetails)].data()["name"].toString()}" +
                                              " on ${displayReplies[index].data()["dateAndTime"].toString()}",
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
  // only suitable for small user base
  int userIdx = 0;
  if (userDetails.hasData) {
    for (int i = 0; i < userDetails.data.length; i++) {
      if (userDetails.data[i].id.toString().compareTo(currPostIDX) == 0) {
        userIdx = i;
        i = userDetails.data.length; // exit the iteration once found
      }
    }
  }
  return userIdx;
}

List<DocumentSnapshot> sortByPopularity(AsyncSnapshot forum) {
  // default unsorted forum retrieved is already sorted by time
  // sorted forum is sorted by popularity
  // sorting algorithm is insertion sort
  // only suitable for small user base

  List<DocumentSnapshot> sortedForum = List.from(forum.data);
  List<int> votes = []..length = forum.data.length;

  for (int i = 0; i < forum.data.length; i++) {
    votes[i] =
        forum.data[i].data()['upvote'] - forum.data[i].data()['downvote'];
  }

  int votePlaceholder;
  DocumentSnapshot forumPlaceholder;
  for (int i = 1; i < forum.data.length; i++) {
    for (int j = i; j > 0; j--) {
      if (votes[j] < votes[j - 1]) {
        votePlaceholder = votes[j];
        votes[j] = votes[j - 1];
        votes[j - 1] = votePlaceholder;

        forumPlaceholder = sortedForum[j];
        sortedForum[j] = sortedForum[j - 1];
        sortedForum[j - 1] = forumPlaceholder;
      }
    }
  }

  return sortedForum;
}
