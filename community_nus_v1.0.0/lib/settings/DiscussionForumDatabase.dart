import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DiscussionForumDatabase {
  final String threadID;
  DiscussionForumDatabase({this.threadID});

  final CollectionReference forum =
      FirebaseFirestore.instance.collection('forum');

  Future create(String title, String threads, String moduleCode, int upvote, int downvote) async {
    return await forum.doc(title).set({
      'title': title,
      'threads': threads,
      'upvote': upvote,
      'downvote': downvote,
      'moduleCode': moduleCode
    });
  }

  Future retrieveAll() async {
    QuerySnapshot query = await forum.get();
    final allData = query.docs;
    return allData;
  }

  Future updateUpvote(String title,int upvote) async {
    return await forum.doc(title).update({
      'upvote': upvote + 1,
    });
  }

  Future updateDownvote(String title,int downvote) async {
    return await forum.doc(title).update({
      'downvote': downvote + 1,
    });
  }

}

// List<Map> disussionForum = [
//   {
//     "title": "CS + Maths DDP",
//     "threads":
//         "hi! does anyone know how do u know if you got offered a ddp haha and in order to get into a ddp must one of the courses be your 1st choice and the other your 2nd choice? for context i placed cs as my 2nd choice and math as my 5th choice (oops) will i not be able to get it? and is it possible for me to appeal during the appealing period to get it? thank you in advance!",
//     "upvote": "56",
//     "downvote": "10",
//   },
//   {
//     "title": "part-time job and double majoring in nus/doing well in uni?",
//     "threads":
//         "hi nus seniors, could you give any advice/thghts on doing a double major and taking up a part time job, specifically both from fass nus if anyone knows! im interested in doing geog + psych and i will likely have a flexi part time job too that has a min commitment of a day/weekend. how difficult is it to get a first class honours and also balance a social life??? ",
//     "upvote": "41",
//     "downvote": "4",
//   },
//   {
//     "title":
//         "To the computer engineering dude that deleted his acct after knowing ik him irl",
//     "threads":
//         "Anyway, just want to reassure you that our conversation and whatever secrets you said will be kept secret even though I am quite angry you kind of ghosted by deleting your account and everything. ",
//     "upvote": "41",
//     "downvote": "4",
//   },
//   {
//     "title": "NUS CS vs NTU CS",
//     "threads":
//         "Context: I planned to join NUS CS but I heard of people who got 87.5 getting rejected last year. So I applied for NTU CS as a backup. I applied for NTU scholarships as well jic i ended up joining NTU CS instead. I ended up getting CNYSP and WCY despite my almost non existent portfolio and questionable interview skills (?) Meanwhile, NUS didn’t invite me down for a scholarship interview.",
//     "upvote": "41",
//     "downvote": "4",
//   },
//   {
//     "title": "PH2211 Philosophy of Religion",
//     "threads":
//         "Has anyone taken this mod? How is the workload and content? The earliest review on NUSMods is 6 years so looking for an updated review.",
//     "upvote": "41",
//     "downvote": "4",
//   },
// ];