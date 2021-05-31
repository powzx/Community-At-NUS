import 'package:community_nus/screens/baseScreenForAllPages.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/screens/notifications.dart';
import 'package:community_nus/settings/comments.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/settings/faculties.dart';
import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/Home_ModulesSelector.dart';
import 'package:community_nus/settings/user_data.dart';

class ViewModules extends StatefulWidget {
  final String fac;
  final String img;
  final String uid;

  ViewModules({this.fac, this.img, this.uid});

  @override
  _ViewModulesState createState() =>
      _ViewModulesState(fac: fac, img: img, uid: uid);
}

class _ViewModulesState extends State<ViewModules> {
  final String fac;
  final String img;
  final String uid;

  _ViewModulesState({this.fac, this.img, this.uid});

  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FacultyDatabase(fac: fac).viewModules(),
        builder: (BuildContext context, AsyncSnapshot faculty) {
          if (faculty.hasData) {
            List modules = List.from(faculty.data.data()["modules"]);
            int length = modules.length;
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
                  "Faculties",
                ),
                elevation: 0.0,
                actions: <Widget>[
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
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 3.2,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "$img",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "${faculty.data.data()["name"]}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 20.0),
                    Row(children: <Widget>[
                      Text(
                        "Modules",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(
                        width: 170.0,
                      ),
                      Text("(Click to add)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ))
                    ]),
                    SizedBox(height: 10.0),
                    // Text(
                    //   "xxxxx",
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w300,
                    //   ),
                    // ),
                    Container(
                      height: 600.0,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: length,
                        itemBuilder: (BuildContext context, int index) {
                          //Map cat = categories[index];
                          return Modules(
                            //icon: cat['icon'],
                            moduleCode: modules[index],
                            isHome: false,
                            tap: () async {
                              await DatabaseService(uid: uid)
                                  .addModules(modules[index]);
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MainScreen(uid: uid);
                              }));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
