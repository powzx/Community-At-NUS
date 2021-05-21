import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
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
      'modules': FieldValue.arrayUnion(['nil']),
      'rep': 0
    });
  }

  Future editUserData(String _name, String _phone, String _faculty, String _course) async {
    return await users.doc(uid).update({
      'name': _name,
      'phone': _phone,
      'faculty': _faculty,
      'course': _course,
    });
  }
  
  Future addModules(String _module) async {
    DocumentSnapshot current = await users.doc(uid).get();
    if (List.from(current.data()["modules"])[0] == "nil") {
      await users.doc(uid).update({
        'modules': FieldValue.arrayUnion([_module])
      });
      return await users.doc(uid).update({
        'modules': FieldValue.arrayRemove(["nil"])
      });
    }
    return await users.doc(uid).update({
      'modules': FieldValue.arrayUnion([_module])
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

  Future retrieveInBulk(List<String> members) async {
    // this function gets document snapshots of every single UID in the list of members given
    int length = members.length;
    List<DocumentSnapshot> usrDetails = [];
    DocumentSnapshot data;

    for (int i = 0; i < length; i++) {
      data = await users.doc(members[i]).get();
      usrDetails.add(data);
    }

    return usrDetails;
  }
}

class StudyLobbyDatabase {
  final String uid;
  StudyLobbyDatabase({this.uid});

  final CollectionReference lobby = FirebaseFirestore.instance.collection('lobby');

  Future create(String _groupName, String _description, String _modules, String _telegram) async {
    return await lobby.doc().set({
      'host_uid': uid,
      'group_name': _groupName,
      'description': _description,
      'modules': _modules,
      'telegram_group': _telegram,
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  Future retrieveAll() async {
    QuerySnapshot query = await lobby.get();
    final allData = query.docs;

    return allData;
  }

  Future addMember(String groupID) async {
    return await lobby.doc(groupID).update({
      'members': FieldValue.arrayUnion([uid]),
    });
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

  Future download() async {
    String downloadURL;
    try {
      downloadURL = await storage.ref('profile_pictures/$uid').getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      //downloadURL = await storage.ref('profile_pictures/default.png').getDownloadURL();
    }
    return downloadURL;
  }
}

class FacultyDatabase {
  final String fac;

  FacultyDatabase({this.fac});

  final CollectionReference faculties = FirebaseFirestore.instance.collection('faculties');

  Future viewModules() async {
    return await faculties.doc(fac).get();
  }
}