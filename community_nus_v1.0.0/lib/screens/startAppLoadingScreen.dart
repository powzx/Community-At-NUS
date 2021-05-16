import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/screens/join.dart';

class startAppLoadingScreen extends StatefulWidget {
  @override
  _startAppLoadingScreenState createState() => _startAppLoadingScreenState();
}

class _startAppLoadingScreenState extends State<startAppLoadingScreen> {
  startTimeout() {
    return Timer(Duration(seconds: 2), changeScreen);
  }

  changeScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return JoinApp();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "images/applogo.png",
                fit: BoxFit.contain,
                width: 230.0,
                height: 250.0,
              ),
              SizedBox(width: 20.0),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 30.0,
                ),
                child: Text(
                  "${Constants.appName}",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
