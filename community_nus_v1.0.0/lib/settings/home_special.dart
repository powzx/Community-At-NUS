import 'package:flutter/material.dart';
import 'package:community_nus/settings/user_data.dart';

class Special extends StatefulWidget {
  @override
  _SpecialState createState() => _SpecialState();
}

class _SpecialState extends State<Special> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HTTP().fetchNews(),
      builder: (BuildContext context, AsyncSnapshot news) {
        if (news.hasData) {
          return ListView.builder(
            itemCount: news.data.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16.0),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  news.data[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(news.data[index].description),
              );
            },
          );
        }
        return LinearProgressIndicator();
      },
    );
  }
}
