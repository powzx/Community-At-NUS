import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  final String uid;
  final bool upSize;
  final int rep;

  ProfilePic({this.uid, this.upSize, this.rep});

  @override
  _ProfilePicState createState() =>
      _ProfilePicState(uid: uid, upSize: upSize, rep: rep);
}

class _ProfilePicState extends State<ProfilePic> {
  final String uid;
  final bool upSize;
  final int rep;

  _ProfilePicState({this.uid, this.upSize, this.rep});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DownloadImage(uid: uid).download(),
      builder: (BuildContext context, AsyncSnapshot profilePic) {
        return CircleAvatar(
          radius: upSize ? 45.0 : 30.0,
          backgroundColor: (rep < 100)
              ? Colors.white
              : (rep < 200)
                  ? Colors.yellow
                  : (rep < 300)
                      ? Colors.orange
                      : (rep < 400)
                          ? Colors.green
                          : (rep < 500)
                              ? Colors.purple
                              : (rep < 600)
                                  ? Colors.blue
                                  : (rep < 700)
                                      ? Colors.teal
                                      : (rep < 800)
                                          ? Colors.brown
                                          : (rep < 900)
                                              ? Colors.red
                                              : (rep < 1000)
                                                  ? Colors.pink
                                                  : Colors.black,
          child: CircleAvatar(
            radius: upSize ? 40.0 : 25.0,
            backgroundImage: (profilePic.hasData)
                ? NetworkImage("${profilePic.data}")
                : AssetImage("images/default.png"),
          ),
        );
      },
    );
  }
}
