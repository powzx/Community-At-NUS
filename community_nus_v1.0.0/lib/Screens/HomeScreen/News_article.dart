import 'dart:async';
import 'package:flutter/material.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DisplayArticle extends StatefulWidget {
  final Article article;
  final String uid;

  DisplayArticle({this.article, this.uid});

  @override
  _DisplayArticleState createState() =>
      _DisplayArticleState(article: article, uid: uid);
}

class _DisplayArticleState extends State<DisplayArticle> {
  final Article article;
  final String uid;

  String title;
  String content;

  _DisplayArticleState({this.article, this.uid});

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text("Trending News"),
          elevation: 0.0,
        ),
        body: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              initialUrl: article.articleUrl,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Create a new thread"),
                      content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  title = value.trim();
                                });
                              },
                              decoration: InputDecoration(hintText: "Title"),
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  content = value.trim();
                                });
                              },
                              decoration: InputDecoration(hintText: "Content"),
                            ),
                          ]),
                      actions: [
                        TextButton(
                          child: Text("CANCEL"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("CREATE"),
                          onPressed: () async {
                            await DiscussionForumDatabase(uid: uid).create(
                                title,
                                article.articleUrl + "\n" + "\n" + content,
                                "[General]",
                                0,
                                0,
                                DateTime.now().toString().substring(0, 10));
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        )
                      ],
                    );
                  });
            },
            tooltip: "Create a discussion thread",
            child: const Icon(Icons.forum),
          ),
        ));
  }
}
