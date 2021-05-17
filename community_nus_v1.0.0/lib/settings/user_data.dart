import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String _name, String _email, String _phone, String _faculty, String _course) async {
    return await users.doc(uid).set({
      'name': _name,
      'email': _email,
      'phone': _phone,
      'faculty': _faculty,
      'course': _course,
    });
  }
}

class RetrieveUserInfo {

  final String uid;
  RetrieveUserInfo({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future startRetrieve() async {
    return await users.doc(uid).get();
  }
}

class UploadImage {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File img;
  final String uid;

  UploadImage({this.img, this.uid});

  Future upload() async {
    // String fileName = basename(img.path);
    try {
      await storage.ref().child('profile_pictures/$uid').putFile(img);
    } on firebase_storage.FirebaseException catch (e) {
      // will create an alertDialog for error management
    }
  }
}

class DownloadImage {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final String uid;

  DownloadImage({this.uid});

  Future<String> download() async {
    String downloadURL;
    try {
      downloadURL = await storage.ref('profile_pictures/$uid').getDownloadURL();
      return downloadURL;
    } on firebase_storage.FirebaseException catch (e) {
      downloadURL = await storage.ref('profile_pictures/default.png').getDownloadURL();
      return downloadURL;
    }
  }
}