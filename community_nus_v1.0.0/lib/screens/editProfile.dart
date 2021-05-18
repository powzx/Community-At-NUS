import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:community_nus/screens/profile.dart';
import 'package:community_nus/screens/baseScreenForAllPages.dart';

/* UI needs to be improved.
* */

class EditProfile extends StatefulWidget {
  final String uid;
  final String originalName;
  final String originalPhone;
  final String originalFaculty;
  final String originalCourse;

  EditProfile({this.uid, this.originalName, this.originalPhone, this.originalFaculty, this.originalCourse});

  @override
  _EditProfileState createState() => _EditProfileState(uid, originalName, originalPhone, originalFaculty, originalCourse);
}

class _EditProfileState extends State<EditProfile> {
  String uid;
  TextEditingController nameController;
  TextEditingController phoneController;
  TextEditingController facultyController;
  TextEditingController courseController;

  _EditProfileState(String uid, String originalName, String originalPhone, String originalFaculty, String originalCourse) {
    this.uid = uid;
    nameController = TextEditingController(text: originalName);
    phoneController = TextEditingController(text: originalPhone);
    facultyController = TextEditingController(text: originalFaculty);
    courseController = TextEditingController(text: originalCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 40.0),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: 25.0,
              ),
              child: ElevatedButton(
                child: Text(
                  "Edit Profile Picture",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  File _image;

                  Future _imgFromCamera() async {
                    // camera is not working -- will be fixed
                    PickedFile image = await ImagePicker()
                        .getImage(source: ImageSource.camera, imageQuality: 50);
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
                                    leading: new Icon(Icons.photo_library),
                                    title: new Text('Gallery'),
                                    onTap: () async {
                                      await _imgFromGallery();
                                      Navigator.of(context).pop();
                                      await UploadImage(img: _image, uid: uid)
                                          .upload();
                                    }),
                                new ListTile(
                                  leading: new Icon(Icons.photo_camera),
                                  title: new Text('Camera'),
                                  onTap: () async {
                                    await _imgFromCamera();
                                    Navigator.of(context).pop();
                                    await UploadImage(img: _image, uid: uid)
                                        .upload();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              )),
          SizedBox(height: 30.0),
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
                controller: nameController,
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
                  hintText: "Name",
                  prefixIcon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {
                  //setState(() {
                    //nameController.text = value.trim();
                  //});
                },
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
                controller: phoneController,
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
                  hintText: "Phone Number",
                  prefixIcon: Icon(
                    Icons.local_phone_outlined,
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
                controller: facultyController,
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
                  hintText: "Faculty",
                  prefixIcon: Icon(
                    Icons.school_outlined,
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
                controller: courseController,
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
                  hintText: "Course",
                  prefixIcon: Icon(
                    Icons.book_outlined,
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
                await DatabaseService(uid: uid)
                    .editUserData(nameController.text, phoneController.text, facultyController.text, courseController.text);
                Navigator.of(context).pop();
                // to be improved -- need to refresh to view changes
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 10.0),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
