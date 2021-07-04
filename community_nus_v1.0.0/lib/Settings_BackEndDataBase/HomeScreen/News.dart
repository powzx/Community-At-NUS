import 'package:community_nus/Screens/HomeScreen/News_article.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:flutter/material.dart';

class Special extends StatefulWidget {
  final String uid;

  Special({this.uid});

  @override
  _SpecialState createState() => _SpecialState(uid: uid);
}

class _SpecialState extends State<Special> {
  final String uid;

  _SpecialState({this.uid});

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
              return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DisplayArticle(
                        article: news.data[index],
                        uid: uid,
                      );
                    })).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 24),
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(6),
                              bottomLeft: Radius.circular(6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                news.data[index].urlToImage,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              news.data[index].title,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              news.data[index].description,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          );
        }
        return LinearProgressIndicator();
      },
    );
  }
}
