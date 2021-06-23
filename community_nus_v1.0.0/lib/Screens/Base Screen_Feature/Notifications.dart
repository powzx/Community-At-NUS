import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/Settings_BackEndDataBase/NotificationTile.dart';

class Notifications extends StatefulWidget {
  final String uid;

  Notifications({this.uid});

  @override
  _NotificationsState createState() => _NotificationsState(uid: uid);
}

class _NotificationsState extends State<Notifications> {
  final String uid;

  _NotificationsState({this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Notifications",
        ),
        elevation: 0.0,
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                NotificationsDatabase(uid: uid).clear();
                setState(() {});
              },
              child: Text(
                "Clear"
              )),
        ],
      ),
      body: FutureBuilder(
          future: NotificationsDatabase(uid: uid).getDataAndRead(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Map> notifMap =
                  List.from(snapshot.data.data()['notifications']);
              if (notifMap.length == 0) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  child: Text(
                    "No notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView.builder(
                  itemCount: notifMap.length,
                  shrinkWrap: true,
                  reverse: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map tile = notifMap[index];
                    return NotificationTile(
                      type: tile['type'],
                      initiator: tile['initiator'],
                      location: tile['location'],
                      datetime: tile['datetime'],
                    );
                  },
                ),
              );
            }
            return LinearProgressIndicator();
          }),
    );
  }
}
