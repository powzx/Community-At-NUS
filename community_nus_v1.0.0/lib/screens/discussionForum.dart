import 'package:community_nus/screens/createDiscussionThread.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/settings/user_data.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DiscussionForumDatabase(uid: uid).retrieveForum(),
        builder: (BuildContext context, AsyncSnapshot forum) {
          if (forum.hasData) {
            return FutureBuilder(
                future: DiscussionForumDatabase(uid: uid).retrieveUser(),
                builder: (BuildContext context, AsyncSnapshot userDetails) {
                  List<QueryDocumentSnapshot> listData = userDetails.data;
                  int userIdx = 0;
                  for (int i = 0; i < userDetails.data.length; i++) {
                    if (listData[i].id.toString().compareTo(this.uid) == 0) {
                      userIdx = i;
                    }
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
                          );
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
                              child: Text(
                                "Discussion Forum",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 6.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Search..",
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  maxLines: 1,
                                  // controller: _searchControl,
                                ),
                              ),
                            ),
                            SizedBox(height: 25),

                            //The list below
                            ListView.separated(
                              itemCount: forum.data.length,
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
                                                          "${forum.data[index].data()["title"].toString()}",
                                                          int.parse(
                                                              "${forum.data[index].data()["upvote"].toString()}"));
                                                  // Navigator.of(context).pop();
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                          Text(
                                            (int.parse("${forum.data[index].data()["upvote"].toString()}") -
                                                    int.parse(
                                                        "${forum.data[index].data()["downvote"].toString()}"))
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
                                                          "${forum.data[index].data()["title"].toString()}",
                                                          int.parse(
                                                              "${forum.data[index].data()["downvote"].toString()}"));
                                                  // Navigator.of(context).pop();
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ]),
                                    title: RichText(
                                      text: TextSpan(
                                          text: "${forum.data[index].data()["moduleCode"].toString()}" +
                                              " " +
                                              "${forum.data[index].data()["title"].toString()}",
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "\n${forum.data[index].data()["threads"].toString()}",
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
                                              "${userDetails.data[userIdx].data()["name"].toString()}" +
                                              " on ${forum.data[index].data()["dateAndTime"].toString()}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {});
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
