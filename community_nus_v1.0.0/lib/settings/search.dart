import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

class ModuleSearch extends SearchDelegate {
  final List<DocumentSnapshot> lobby;
  DocumentSnapshot result;

  ModuleSearch({this.lobby});

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
    final results = lobby.where((module) {
      return module
          .data()['modules']
          .toLowerCase()
          .contains(query.toLowerCase());
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
            leading: Column(
              children: <Widget>[
                Icon(Icons.group),
                Text(
                    '${results.elementAt(index).data()["strength"].toString()}/20'),
              ],
            ),
            title: Text(
              '${results.elementAt(index).data()["group_name"]}',
              style: TextStyle(fontSize: 24),
            ),
            subtitle: Text(
              '${results.elementAt(index).data()["modules"]}',
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
    // suggestions are showing duplicated modules, if cannot solve just don't show as a whole.
    final suggestions = lobby.where((module) {
      return module
          .data()['modules']
          .toLowerCase()
          .contains(query.toLowerCase());
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestions.elementAt(index).data()['modules']),
          onTap: () {
            query = suggestions.elementAt(index).data()['modules'];
          },
        );
      },
    );
  }
}
