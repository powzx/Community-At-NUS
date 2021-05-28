import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

//type 0: (to creator) someone joined your study group

List statement = [
  "has joined your study group",
];

class NotificationTile extends StatefulWidget {
  final int type;
  final String initiator;
  final String location;

  NotificationTile({this.type, this.initiator, this.location});

  @override
  _NotificationTileState createState() =>
      _NotificationTileState(
          type: type, initiator: initiator, location: location);
}

class _NotificationTileState extends State<NotificationTile> {
  final int type;
  final String initiator;
  final String location;

  _NotificationTileState({this.type, this.initiator, this.location});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RetrieveUserInfo(uid: initiator).startRetrieve(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            child: Card(
              child: ListTile(
                title: Text(
                    "${snapshot.data.data()['name']} ${statement[type]} $location."
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}