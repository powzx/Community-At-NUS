import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/screens/studyLobby.dart';
import 'package:community_nus/screens/homeScreen.dart';
import 'package:community_nus/screens/notifications.dart';
import 'package:community_nus/screens/profile.dart';
import 'package:community_nus/screens/discussionForum.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  //final DocumentSnapshot document;
  final String uid;

  MainScreen({this.uid});

  @override
  _MainScreenState createState() => _MainScreenState(uid: uid);
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  //final DocumentSnapshot document;
  final String uid;

  _MainScreenState({this.uid});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Constants.appName,
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
              tooltip: "Refresh",
            ),
            IconButton(
              icon: IconBadge(
                icon: Icons.notifications,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Notifications();
                    },
                  ),
                );
              },
              tooltip: "Notifications",
            ),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Home(uid: uid),
            SearchScreen(),
            StudyLobby(uid: uid),
            Profile(uid: uid),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 26.0,
                ),
                color: _page == 0
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.caption.color,
                onPressed: () => _pageController.jumpToPage(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.forum,
                  size: 24.0,
                ),
                color: _page == 1
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.caption.color,
                onPressed: () => _pageController.jumpToPage(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.group,
                  size: 24.0,
                ),
                color: _page == 2
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.caption.color,
                onPressed: () => _pageController.jumpToPage(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                color: _page == 3
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.caption.color,
                onPressed: () => _pageController.jumpToPage(3),
              ),
              SizedBox(width: 7),
            ],
          ),
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
