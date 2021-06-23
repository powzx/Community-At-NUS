import 'package:community_nus/Screens/DiscussionForum/ModuleForum.dart';
import 'package:flutter/material.dart';

class Modules extends StatefulWidget {
  final String uid;
  final String threads;
  final String moduleCode;
  final Function tap;
  final bool isHome;

  Modules(
      {Key key, this.uid, this.threads, this.moduleCode, this.tap, this.isHome})
      : super(key: key);

  @override
  _ModulesState createState() =>
      _ModulesState(uid: uid, threads: threads, moduleCode: moduleCode);
}

class _ModulesState extends State<Modules> {
  final String uid;
  final String threads;
  final String moduleCode;

  _ModulesState({this.uid, this.threads, this.moduleCode});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isHome
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ModuleForum(this.uid, this.threads, this.moduleCode);
                  },
                ),
              );
            }
          : widget.tap,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    "${widget.moduleCode}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
