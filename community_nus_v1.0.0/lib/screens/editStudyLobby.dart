import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

class EditStudyGroup extends StatefulWidget {
  final String uid;
  final String groupID;
  final String originalDesc;
  final String originalTele;
  final String originalAnnounce;
  final String originalHideout;

  EditStudyGroup(
      {this.uid,
      this.groupID,
      this.originalDesc,
      this.originalTele,
      this.originalAnnounce,
      this.originalHideout});

  @override
  _EditStudyGroupState createState() => _EditStudyGroupState(uid, groupID,
      originalDesc, originalTele, originalAnnounce, originalHideout);
}

class _EditStudyGroupState extends State<EditStudyGroup> {
  String uid;
  String groupID;
  TextEditingController descCon;
  TextEditingController teleCon;
  TextEditingController announceCon;
  TextEditingController hideoutCon;

  _EditStudyGroupState(String uid, String groupID, String originalDesc,
      String originalTele, String originalAnnounce, String originalHideout) {
    this.uid = uid;
    this.groupID = groupID;
    descCon = TextEditingController(text: originalDesc);
    teleCon = TextEditingController(text: originalTele);
    announceCon = TextEditingController(text: originalAnnounce);
    hideoutCon = TextEditingController(text: originalHideout);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 80.0),
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
                controller: descCon,
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
                  hintText: "Description",
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
                onChanged: (value) {},
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
                controller: teleCon,
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
                  hintText: "Telegram Invite Link",
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {},
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
                controller: announceCon,
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
                  hintText: "Announcements",
                  prefixIcon: Icon(
                    Icons.announcement_outlined,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {},
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
                controller: hideoutCon,
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
                  hintText: "Study Hideout",
                  prefixIcon: Icon(
                    Icons.fireplace_outlined,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {},
              ),
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: 50.0,
            child: RaisedButton(
              child: Text(
                "Apply Changes".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await StudyLobbyDatabase(uid: uid).edit(groupID, descCon.text,
                    teleCon.text, announceCon.text, hideoutCon.text);
                Navigator.of(context).pop();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
