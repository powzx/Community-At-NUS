import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

class DiscussionForumDatabase {
  final String uid;

  DiscussionForumDatabase({this.uid});

  final CollectionReference forum =
      FirebaseFirestore.instance.collection('forum');

  Future create(String title, String threads, String moduleCode, int upvote,
      int downvote, String dateAndTime) async {
    return await forum.doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'thread_uid': this.uid,
      'title': title,
      'threads': threads,
      'upvote': upvote,
      'downvote': downvote,
      'moduleCode': moduleCode,
      'dateAndTime': dateAndTime
    });
  }

  Future retrieveModulesForum(String moduleCode) async {
    moduleCode = "[" + moduleCode + "]";
    QuerySnapshot queryforum =
        await forum.where('moduleCode', isEqualTo: moduleCode).get();
    final allData = queryforum.docs;
    return allData;
  }

  Future retrieveForum() async {
    QuerySnapshot queryforum = await forum.get();
    final allData = queryforum.docs;
    return allData;
  }

  Future updateUpvote(String title, int upvote) async {
    return await forum.doc(title).update({
      'upvote': upvote + 1,
    });
  }

  Future updateDownvote(String title, int downvote) async {
    return await forum.doc(title).update({
      'downvote': downvote + 1,
    });
  }
}

class UserDatabase {
  final String uid;

  UserDatabase({this.uid});

  final CollectionReference userInfo =
      FirebaseFirestore.instance.collection('users');

  Future retrieveUser() async {
    QuerySnapshot queryUserInfo = await userInfo.get();
    final allData = queryUserInfo.docs;
    return allData;
  }

  Future increaseRep() async {
    DocumentSnapshot user = await userInfo.doc(uid).get();
    int initial = user.data()['rep'];
    return await userInfo.doc(uid).update({
      'rep': initial + 1,
    });
  }

  Future decreaseRep() async {
    DocumentSnapshot user = await userInfo.doc(uid).get();
    int initial = user.data()['rep'];
    return await userInfo.doc(uid).update({
      'rep': initial - 1,
    });
  }
}

class ForumRepliesDataBase {
  final String uid;

  ForumRepliesDataBase({this.uid});

  final CollectionReference forumReplies =
      FirebaseFirestore.instance.collection('forumReplies');

  Future create(String replies, String title, int upvote, int downvote,
      String dateAndTime) async {
    return await forumReplies.doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'thread_uid': this.uid,
      'replies': replies,
      'title': title,
      'upvote': upvote,
      'downvote': downvote,
      'dateAndTime': dateAndTime
    });
  }

  Future retrieveForumReplies(String input) async {
    QuerySnapshot queryforum =
        await forumReplies.where('title', isEqualTo: input).get();
    final allData = queryforum.docs;
    return allData;
  }

  Future updateUpvote(String replies, int upvote) async {
    return await forumReplies.doc(replies).update({
      'upvote': upvote + 1,
    });
  }

  Future updateDownvote(String replies, int downvote) async {
    return await forumReplies.doc(replies).update({
      'downvote': downvote + 1,
    });
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

  Future retrieveAllModules() async {
    QuerySnapshot query = await faculties.get();
    final allDocs = query.docs;
    List allModules = [];

    for (int i = 0; i < allDocs.length; i++) {
      final modules = allDocs[i].data()['modules'];
      allModules += modules;
    }
    return allModules;
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

class NotificationsDatabase {
  final String uid;

  NotificationsDatabase({this.uid});

  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  Future createDatabase() async {
    return await notifications.doc(uid).set({
      'notifications': [],
      'unread': false,
    });
  }

  Future getData() async {
    return await notifications.doc(uid).get();
  }

  Future getDataAndRead() async {
    await notifications.doc(uid).update({
      'unread': false,
    });
    return await notifications.doc(uid).get();
  }

  Future sendData(
      int type, String initiator, String location, DateTime datetime) async {
    String formattedDateTime = DateFormat('yyyy-MM-dd kk:mm').format(datetime);
    Map data = {
      'type': type,
      'initiator': initiator,
      'location': location,
      'datetime': formattedDateTime
    };
    return await notifications.doc(uid).update({
      'notifications': FieldValue.arrayUnion([data]),
      'unread': true,
    });
  }

  Future clear() async {
    final result = await notifications.doc(uid).get();
    List list = List.from(result.data()['notifications']);
    for (int i = 0; i < list.length; i++) {
      Map entry = list[i];
      await notifications.doc(uid).update({
        'notifications': FieldValue.arrayRemove([entry]),
      });
    }
  }
}
