import 'package:community_nus/Settings_BackEndDataBase/profile_pic.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/material.dart';

/*
* To add a notification:
* 1. Add the statement --> Type number of your notification will be the index
* 2. Add definition of your notification below
* 3. Call NotificationsDatabase().sendData() in the widget to send from
* --> Initiator: Who sends the notification?
* --> Location: Where did the notification take place?
* --> Type: Notification type
*/

//type 0: (to creator) someone joined your study group
//type 1: (to members) creator edited the study group
//type 2: (to OP) someone replied post

List statement = [
  "has joined your study group",
  "has made changes to your study group",
  "has replied to your post",
];

class NotificationTile extends StatefulWidget {
  final int type;
  final String initiator;
  final String location;
  final String datetime;

  NotificationTile({this.type, this.initiator, this.location, this.datetime});

  @override
  _NotificationTileState createState() => _NotificationTileState(
      type: type, initiator: initiator, location: location, datetime: datetime);
}

class _NotificationTileState extends State<NotificationTile> {
  final int type;
  final String initiator;
  final String location;
  final String datetime;

  _NotificationTileState(
      {this.type, this.initiator, this.location, this.datetime});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RetrieveUserInfo(uid: initiator).startRetrieve(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            child: Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: ProfilePic(
                    uid: initiator,
                    upSize: false,
                    rep: snapshot.data.data()['rep'],
                  ),
                  title: Text(
                      "${snapshot.data.data()['name']} ${statement[type]} $location."),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[Text(datetime)],
                )
              ]),
            ),
          );
        }
        return Container();
      },
    );
  }
}
