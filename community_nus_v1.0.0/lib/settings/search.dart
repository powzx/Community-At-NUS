import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
    // suggestions now based on the faculties collection of our database.
    // module codes that do not exist in the database and yet have study groups are NOT being suggested, but results will still show.
    // efficiency may be lower when the database of faculties becomes larger.
    return FutureBuilder(
        future: FacultyDatabase().retrieveAllModules(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List modules = snapshot.data;
            final suggestions = modules.where((module) {
              return module.toLowerCase().contains(query.toLowerCase());
            });
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(suggestions.elementAt(index)),
                  onTap: () {
                    query = suggestions.elementAt(index);
                  },
                );
              },
            );
          }
          return LinearProgressIndicator();
        });
  }
}

class ForumSearch extends SearchDelegate {
  final List moduleList;
  String result;

  ForumSearch({this.moduleList});

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
    final results = moduleList.where((module) {
      return module.toLowerCase().contains(query.toLowerCase());
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
        return ListTile(
          title: Text(results.elementAt(index)),
          onTap: () {
            result = results.elementAt(index);
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = moduleList.where((module) {
      return module.toLowerCase().contains(query.toLowerCase());
    });

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestions.elementAt(index)),
          onTap: () {
            query = suggestions.elementAt(index);
          },
        );
      },
    );
  }
}
