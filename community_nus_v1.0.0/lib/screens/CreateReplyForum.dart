import 'package:flutter/cupertino.dart';
import 'package:community_nus/screens/DiscussionForum.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:flutter/material.dart';

class CreateReplyForum extends StatefulWidget {
  final String uid;

  CreateReplyForum({this.uid});

  @override
  _CreateReplyForum createState() => _CreateReplyForum(uid: uid);
}

class _CreateReplyForum extends State<CreateReplyForum> {
  final String uid;

  String title;
  String replies;
  String moduleCode;

  _CreateReplyForum({this.uid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 150.0),
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
                  hintText: "Reply",
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
                    replies = value.trim();
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
                await ForumRepliesDataBase(uid: uid).create(
                    replies, 0, 0, DateTime.now().toString().substring(0, 10));
                Navigator.of(context).pop();
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
    );
  }
}
