import 'package:cloud_firestore/cloud_firestore.dart';

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