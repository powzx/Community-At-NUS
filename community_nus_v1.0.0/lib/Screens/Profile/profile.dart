import 'dart:io';
import 'package:community_nus/Screens/Base%20Screen_Feature/StartAppLoadingScreen.dart';
import 'package:community_nus/Screens/Profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_nus/Settings_BackEndDataBase/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:community_nus/Settings_BackEndDataBase/profile_pic.dart';

/* bugs:
* uploading profile pic only works with gallery, not camera.
* have to refresh the page to view profile changes after editing profile.
* */

class Profile extends StatefulWidget {
  //final DocumentSnapshot document;
  final String uid;

  Profile({this.uid});

  @override
  _ProfileState createState() => _ProfileState(uid: uid);
}

class _ProfileState extends State<Profile> {
  //final DocumentSnapshot document;
  final String uid;

  _ProfileState({this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RetrieveUserInfo(uid: uid).startRetrieve(),
        builder: (BuildContext context, AsyncSnapshot user) {
          if (user.hasData) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: ProfilePic(
                              uid: uid,
                              upSize: true,
                              rep: user.data.data()["rep"]),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    user.data.data()["name"],
                                    //document.data()["name"],
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Reputation: ",
                                    //document.data()["email"],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.data.data()["rep"].toString(),
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return startAppLoadingScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          flex: 3,
                        ),
                      ],
                    ),
                    Divider(),
                    Container(height: 15.0),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Account Information".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        user.data.data()["name"],
                        //document.data()["name"],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return EditProfile(
                                    uid: uid,
                                    originalName: user.data.data()["name"],
                                    originalPhone: user.data.data()["phone"],
                                    originalFaculty:
                                        user.data.data()["faculty"],
                                    originalCourse: user.data.data()["course"]);
                              },
                            ),
                          ).then((value) {
                            setState(() {});
                          });
                        },
                        tooltip: "Edit",
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        user.data.data()["email"],
                        //document.data()["email"],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        user.data.data()["phone"],
                        //document.data()["phone"],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Faculty",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        user.data.data()["faculty"],
                        //document.data()["faculty"],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Course",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        user.data.data()["course"],
                        //document.data()["course"],
                      ),
                    ),
                    //The following code is for the dark theme button! 

                    // MediaQuery.of(context).platformBrightness == Brightness.dark
                    //     ? SizedBox()
                    //     : ListTile(
                    //         title: Text(
                    //           "Dark Theme",
                    //           style: TextStyle(
                    //             fontSize: 17,
                    //             fontWeight: FontWeight.w700,
                    //           ),
                    //         ),
                    //         trailing: Switch(
                    //           value: Provider.of<AppProvider>(context).theme ==
                    //                   Constants.lightTheme
                    //               ? false
                    //               : true,
                    //           onChanged: (v) async {
                    //             if (v) {
                    //               Provider.of<AppProvider>(context,
                    //                       listen: false)
                    //                   .setTheme(Constants.darkTheme, "dark");
                    //             } else {
                    //               Provider.of<AppProvider>(context,
                    //                       listen: false)
                    //                   .setTheme(Constants.lightTheme, "light");
                    //             }
                    //           },
                    //           activeColor: Theme.of(context).accentColor,
                    //         ),
                    //       ),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
