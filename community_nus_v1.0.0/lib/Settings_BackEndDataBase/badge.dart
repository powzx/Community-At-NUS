import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/material.dart';

class IconBadge extends StatefulWidget {

  final IconData icon;
  final double size;
  final String uid;

  IconBadge(
      {Key key, @required this.icon, @required this.size, @required this.uid})
      : super(key: key);


  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<IconBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          widget.icon,
          size: widget.size,
        ),
        Positioned(
            right: 0.0,
            child: FutureBuilder(
                future: NotificationsDatabase(uid: widget.uid).getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data()['unread']) {
                      return Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 13,
                          minHeight: 13,
                        ),
                      );
                    }
                    return Container();
                  }
                  return Container();
                }
            )
        ),
      ],
    );
  }
}
