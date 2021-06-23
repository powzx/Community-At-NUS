import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/Screens/BaseScreen_Feature/Notifications.dart';
import 'package:community_nus/Settings_BackEndDataBase/Badge.dart';
import 'package:community_nus/Settings_BackEndDataBase/Constant.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';

class EditStudyGroup extends StatefulWidget {
  final String uid;
  final DocumentSnapshot groupDetails;
  final String originalDesc;
  final String originalTele;
  final String originalAnnounce;
  final String originalHideout;
  final List members;

  EditStudyGroup(
      {this.uid,
      this.groupDetails,
      this.originalDesc,
      this.originalTele,
      this.originalAnnounce,
      this.originalHideout,
      this.members});

  @override
  _EditStudyGroupState createState() => _EditStudyGroupState(uid, groupDetails,
      originalDesc, originalTele, originalAnnounce, originalHideout, members);
}

class _EditStudyGroupState extends State<EditStudyGroup> {
  String uid;
  DocumentSnapshot groupDetails;
  List members;
  TextEditingController descCon;
  TextEditingController teleCon;
  TextEditingController announceCon;
  TextEditingController hideoutCon;

  _EditStudyGroupState(
      String uid,
      DocumentSnapshot groupDetails,
      String originalDesc,
      String originalTele,
      String originalAnnounce,
      String originalHideout,
      List members) {
    this.uid = uid;
    this.groupDetails = groupDetails;
    this.members = members;
    descCon = TextEditingController(text: originalDesc);
    teleCon = TextEditingController(text: originalTele);
    announceCon = TextEditingController(text: originalAnnounce);
    hideoutCon = TextEditingController(text: originalHideout);
  }

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
                  await StudyLobbyDatabase(uid: uid).edit(
                      groupDetails.id,
                      descCon.text,
                      teleCon.text,
                      announceCon.text,
                      hideoutCon.text);
                  for (int i = 1; i < members.length; i++) {
                    await NotificationsDatabase(uid: members[i]).sendData(1,
                        uid, groupDetails.data()['group_name'], DateTime.now());
                  }
                  Navigator.of(context).pop();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
