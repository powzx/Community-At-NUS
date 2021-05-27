import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String _name, String _email, String _phone,
      String _faculty, String _course) async {
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

  Future editUserData(
      String _name, String _phone, String _faculty, String _course) async {
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

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

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

  final CollectionReference lobby =
      FirebaseFirestore.instance.collection('lobby');

  Future create(String _groupName, String _description, String _modules,
      String _telegram) async {
    final DocumentReference group = lobby.doc();
    await group.set({
      'host_uid': uid,
      'group_name': _groupName,
      'modules': _modules,
      'strength': 1,
    });
    return await group.collection('details').doc('details').set({
      'description': _description,
      'telegram_group': _telegram,
      'members': FieldValue.arrayUnion([uid]),
      'announcement': '-',
      'hideout': '-',
    });
  }

  Future edit(String groupID, String _description, String _telegram,
      String _announcement, String _hideout) async {
    return await lobby
        .doc(groupID)
        .collection('details')
        .doc('details')
        .update({
      'description': _description,
      'telegram_group': _telegram,
      'announcement': _announcement,
      'hideout': _hideout,
    });
  }

  Future retrieveAll() async {
    // to retrieve all basic info about all study groups to display in lobby
    QuerySnapshot query = await lobby.get();
    final allData = query.docs;

    return allData;
  }

  Future addMember(DocumentSnapshot group) async {
    int initial = group.data()['strength'];
    await lobby.doc(group.id).update({
      'strength': initial + 1,
    });
    return await lobby
        .doc(group.id)
        .collection('details')
        .doc('details')
        .update({
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  Future retrieveDetailsForGroup(DocumentSnapshot group) async {
    // retrieve additional info about a particular group that is clicked by the user
    DocumentSnapshot details =
        await lobby.doc(group.id).collection('details').doc('details').get();
    return details;
  }
}

class UploadImage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
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
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
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

  final CollectionReference faculties =
      FirebaseFirestore.instance.collection('faculties');

  Future viewModules() async {
    return await faculties.doc(fac).get();
  }
}

class Article {
  String title;
  String author;
  String description;
  String urlToImage;
  String publishedAt;
  String content;
  String articleUrl;

  Article(
      {this.title,
      this.description,
      this.author,
      this.content,
      this.publishedAt,
      this.urlToImage,
      this.articleUrl});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      publishedAt: json['publishedAt'] as String,
      urlToImage: json['urlToImage'] as String,
      articleUrl: json['url'] as String,
    );
  }
}

class HTTP {
  Future fetchNews() async {
    final endPointUrl = 'newsapi.org';
    final client = http.Client();
    List<Article> list = [];
    final queryParameters = {
      'country': 'sg',
      //'category': 'technology',
      'apiKey': '92b56caf9f6b4044bf672a23b2cec660',
    };
    final url = Uri.https(endPointUrl, '/v2/top-headlines', queryParameters);
    final response = await client.get(url);
    final decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      decodedResponse['articles'].forEach((element) {
        Article article = Article.fromJson(element);
        if (article.description != null && article.urlToImage != null)
          list.add(article);
      });
    }
    return list;
  }
}
