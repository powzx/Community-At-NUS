import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:community_nus/screens/DiscussionForum.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:flutter/material.dart';

import 'notifications.dart';

class CreateThreadModulePage extends StatefulWidget {
  final String uid;
  final String moduleCode;

  CreateThreadModulePage({this.uid, this.moduleCode});

  @override
  _CreateThreadModulePage createState() =>
      _CreateThreadModulePage(uid: uid, moduleCode: moduleCode);
}

class _CreateThreadModulePage extends State<CreateThreadModulePage> {
  final String uid;

  String title;
  String threads;
  final String moduleCode;

  _CreateThreadModulePage({this.uid, this.moduleCode});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(6, 6, 6.0, 2),
              child: Text(
                "Start New Thread:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Card(
              elevation: 3.0,
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
                    hintText: "Title",
                    prefixIcon: Icon(
                      Icons.group_outlined,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      title = value.trim();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              elevation: 3.0,
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
                    hintText: "Content",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      threads = value.trim();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              height: 50.0,
              child: RaisedButton(
                child: Text(
                  "Create".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await DiscussionForumDatabase(uid: uid).create(
                      title,
                      threads,
                      "[" + this.moduleCode + "]",
                      0,
                      0,
                      DateTime.now().toString().substring(0, 10));
                  Navigator.of(context).pop();
                  setState(() {});
                  // to be improved -- need to refresh to view changes
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(height: 10.0),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
