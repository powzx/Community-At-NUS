import 'dart:async';

import 'package:flutter/material.dart';
import 'package:community_nus/Settings_BackEndDataBase/user_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DisplayArticle extends StatefulWidget {
  final Article article;

  DisplayArticle({this.article});

  @override
  _DisplayArticleState createState() => _DisplayArticleState(article: article);
}

class _DisplayArticleState extends State<DisplayArticle> {
  final Article article;

  _DisplayArticleState({this.article});

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
    );
  }
}
