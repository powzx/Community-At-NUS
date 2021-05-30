import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

class ForumSearch extends SearchDelegate {
  final List<DocumentSnapshot> forum;
  DocumentSnapshot result;

  ForumSearch({this.forum});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = forum.where((thread) {
      return thread.data()['title'].toLowerCase().contains(query.toLowerCase());
    });

    if (results.length == 0) {
      return ListTile(
        title: Text(
          "No results found",
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(
              '${results.elementAt(index).data()["title"]}',
              style: TextStyle(fontSize: 24),
            ),
            subtitle: Text(
              '${results.elementAt(index).data()["threads"]}',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              result = results.elementAt(index);
              close(context, result);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // suggestions are showing duplicated threads, if cannot solve just don't show as a whole.
    final suggestions = forum.where((thread) {
      return thread
          .data()['threads']
          .toLowerCase()
          .contains(query.toLowerCase());
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestions.elementAt(index).data()['title']),
          onTap: () {
            query = suggestions.elementAt(index).data()['title'];
          },
        );
      },
    );
  }
}
