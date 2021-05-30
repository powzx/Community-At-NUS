import 'package:community_nus/screens/createDiscussionThread.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/screens/notifications.dart';
import 'package:community_nus/settings/my_modules.dart';
import 'package:community_nus/settings/faculties.dart';
import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/home_Faculties.dart';
import 'package:community_nus/screens/DiscussionForum.dart';
import 'package:community_nus/settings/user_data.dart';

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
                          "This page is still not functioning! will update in near future",
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
                            // title: Text(
                            //   "${thread['title']}" + "\n\n${thread['threads']}\n",
                            //   style: TextStyle(
                            //     fontSize: 17,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            title: RichText(
                              text: TextSpan(
                                  text:
                                      "${forum.data[index].data()["title"].toString()}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "\n\n${forum.data[index].data()["threads"].toString()}\n",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ]),
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Wrap(
                                      spacing: 5,
                                      direction: Axis.horizontal,
                                      verticalDirection: VerticalDirection.up,
                                      children: <Widget>[
                                        ClipOval(
                                          child: Material(
                                            color: Colors
                                                .grey.shade200, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.green, // inkwell color
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.green,
                                                  size: 18,
                                                ),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${forum.data[index].data()["upvote"].toString()}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        ClipOval(
                                          child: Material(
                                            color: Colors
                                                .grey.shade200, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.red, // inkwell color
                                              child: SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${forum.data[index].data()["downvote"].toString()}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ]),
                                )
                              ],
                            ),
                            onTap: () {},
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
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
}