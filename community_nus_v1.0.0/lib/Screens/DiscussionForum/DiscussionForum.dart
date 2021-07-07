import 'package:community_nus/Screens/DiscussionForum/CreateDiscussionThread.dart';
import 'package:community_nus/Screens/DiscussionForum/ModuleForum.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/Settings_BackEndDataBase/Constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:community_nus/Settings_BackEndDataBase/Search.dart';
import 'DiscussionForumDetails.dart';
import 'package:community_nus/Settings_BackEndDataBase/Profile_pic.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen>
//     with AutomaticKeepAliveClientMixin<SearchScreen> {
//   final TextEditingController _searchControl = new TextEditingController();

class DiscussionForum extends StatefulWidget {
  final String uid;

  DiscussionForum({this.uid});

  @override
  _DiscussionForumState createState() => _DiscussionForumState(uid: uid);
}

class _DiscussionForumState extends State<DiscussionForum> {
  final String uid;

  _DiscussionForumState({this.uid});

  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DiscussionForumDatabase(uid: uid).retrieveForum(),
        builder: (BuildContext context, AsyncSnapshot forum) {
          if (forum.hasData) {
            return FutureBuilder(
                future: UserDatabase(uid: uid).retrieveUser(),
                builder: (BuildContext context, AsyncSnapshot userDetails) {
                  if (userDetails.hasData) {
                    //   int userIdx = 0;
                    //   for (int i = 0; i < userDetails.data.length; i++) {
                    //     if (userDetails.data[i].id
                    //             .toString()
                    //             .compareTo(this.uid) ==
                    //         0) {
                    //       userIdx = i;
                    //     }
                    //   }

                    List<DocumentSnapshot> sortedForum =
                        sortByPopularity(forum);
                    List<DocumentSnapshot> displayForum;
                    if (flag == 0) {
                      displayForum = forum.data;
                    } else {
                      displayForum = sortedForum;
                    }

                    return Scaffold(
                        floatingActionButton: FloatingActionButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CreateDiscussionThread(uid: uid);
                                },
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          tooltip: "Start a new Thread",
                          child: const Icon(Icons.add),
                        ),
                        body: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5.0, 10),
                          child: ListView(
                            children: <Widget>[
                              SizedBox(height: 5.0),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Discussion Forum",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        icon: Icon(Icons.search),
                                        tooltip: "Search",
                                        onPressed: () async {
                                          final moduleList =
                                              await FacultyDatabase()
                                                  .retrieveAllModules();

                                          final result = await showSearch(
                                              context: context,
                                              delegate: ForumSearch(
                                                  moduleList: moduleList +
                                                      ['General']));

                                          if (result != null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return ModuleForum(uid, '',
                                                  result); // KIV for the empty string
                                            })).then((value) {
                                              setState(() {});
                                            });
                                          }
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.sort),
                                        tooltip: "Sort",
                                        onPressed: () async {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SafeArea(
                                                  child: Container(
                                                    child: new Wrap(
                                                      children: <Widget>[
                                                        new ListTile(
                                                            title: new Text(
                                                                'Most Popular'),
                                                            onTap: () async {
                                                              flag = 1;
                                                              setState(() {});
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }),
                                                        new ListTile(
                                                          title: new Text(
                                                              'Most Recent'),
                                                          onTap: () async {
                                                            flag = 0;
                                                            setState(() {});
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        })
                                  ],
                                ),
                              ),

                              SizedBox(height: 15),

                              //The list below
                              ListView.separated(
                                itemCount: displayForum.length,
                                shrinkWrap: true,
                                primary: false,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                // itemCount:
                                //     disussionForum == null ? 0 : disussionForum.length,
                                // itemBuilder: (BuildContext context, int index) {
                                //   Map thread = disussionForum[index];

                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: ProfilePic(
                                        key: UniqueKey(),
                                        uid: displayForum[index]
                                            .data()["thread_uid"],
                                        upSize: false,
                                        rep: userDetails.data[getUserIdx(
                                                "${displayForum[index].data()["thread_uid"].toString()}",
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
                                                  await DiscussionForumDatabase(
                                                          uid: uid)
                                                      .updateUpvote(
                                                          "${displayForum[index].id}",
                                                          int.parse(
                                                              "${displayForum[index].data()["upvote"].toString()}"));
                                                  await UserDatabase(
                                                          uid: displayForum[
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
                                            (int.parse("${displayForum[index].data()["upvote"].toString()}") -
                                                    int.parse(
                                                        "${displayForum[index].data()["downvote"].toString()}"))
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
                                                  await DiscussionForumDatabase(
                                                          uid: uid)
                                                      .updateDownvote(
                                                          "${displayForum[index].id}",
                                                          int.parse(
                                                              "${displayForum[index].data()["downvote"].toString()}"));
                                                  await UserDatabase(
                                                          uid: displayForum[
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
                                          text: "${displayForum[index].data()["moduleCode"].toString()}" +
                                              " " +
                                              "${displayForum[index].data()["title"].toString()}",
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "\n${displayForum[index].data()["threads"].toString()}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                          ]),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          "\nPosted by " +
                                              "${userDetails.data[getUserIdx("${displayForum[index].data()["thread_uid"].toString()}", userDetails)].data()["name"].toString()}" +
                                              " on ${displayForum[index].data()["dateAndTime"].toString()}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ForumDetails(
                                              uid: uid,
                                              creator_uid:
                                                  "${displayForum[index].data()['thread_uid'].toString()}",
                                              title:
                                                  "${displayForum[index].data()["title"].toString()}",
                                              moduleCode:
                                                  "${displayForum[index].data()["moduleCode"].toString()}",
                                              threads:
                                                  "${displayForum[index].data()["threads"].toString()}",
                                              dateOfCreation:
                                                  "${displayForum[index].data()["dateAndTime"].toString()}",
                                            );
                                          },
                                        ),
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },
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
                  // return CircularProgressIndicator();
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
      } else {
        j = 0;
      }
    }
  }

  return sortedForum;
}
