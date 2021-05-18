import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_nus/screens/startAppLoadingScreen.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/settings/app_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:image_picker/image_picker.dart';

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
                            child: FutureBuilder(
                                future: DownloadImage(uid: uid).download(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return ClipOval(
                                      child: Image.network(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                        width: 80.0,
                                        height: 80.0,
                                      ),
                                    );
                                  }
                                  return ClipOval(
                                    child: Image.asset(
                                      "images/default.png",
                                      fit: BoxFit.cover,
                                      width: 80.0,
                                      height: 80.0,
                                    ),
                                  );
                                })),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    user.data.data()["email"],
                                    //document.data()["email"],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                        onPressed: () async {
                          // edit button only edits profile picture for now -- will be modified
                          File _image;

                          Future _imgFromCamera() async {
                            // camera is not working -- will be fixed
                            PickedFile image = await ImagePicker().getImage(
                                source: ImageSource.camera, imageQuality: 50);
                            setState(() {
                              _image = File(image.path);
                            });
                          }

                          Future _imgFromGallery() async {
                            PickedFile image = await ImagePicker().getImage(
                                source: ImageSource.gallery, imageQuality: 50);

                            setState(() {
                              _image = File(image.path);
                            });
                          }

                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext bc) {
                                return SafeArea(
                                  child: Container(
                                    child: new Wrap(
                                      children: <Widget>[
                                        new ListTile(
                                            leading:
                                                new Icon(Icons.photo_library),
                                            title: new Text('Gallery'),
                                            onTap: () async {
                                              await _imgFromGallery();
                                              Navigator.of(context).pop();
                                              await UploadImage(
                                                      img: _image, uid: uid)
                                                  .upload();
                                            }),
                                        new ListTile(
                                          leading: new Icon(Icons.photo_camera),
                                          title: new Text('Camera'),
                                          onTap: () async {
                                            await _imgFromCamera();
                                            Navigator.of(context).pop();
                                            await UploadImage(
                                                    img: _image, uid: uid)
                                                .upload();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
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
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? SizedBox()
                        : ListTile(
                            title: Text(
                              "Dark Theme",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: Switch(
                              value: Provider.of<AppProvider>(context).theme ==
                                      Constants.lightTheme
                                  ? false
                                  : true,
                              onChanged: (v) async {
                                if (v) {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .setTheme(Constants.darkTheme, "dark");
                                } else {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .setTheme(Constants.lightTheme, "light");
                                }
                              },
                              activeColor: Theme.of(context).accentColor,
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
