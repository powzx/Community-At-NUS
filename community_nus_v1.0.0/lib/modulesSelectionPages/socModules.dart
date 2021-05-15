import 'package:flutter/material.dart';
import 'package:community_nus/screens/notifications.dart';
import 'package:community_nus/settings/comments.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/settings/faculties.dart';
import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/home.Module.dart';
import 'package:community_nus/settings/soc_modules.dart';

class SOCModules extends StatefulWidget {
  @override
  _SOCModulesState createState() => _SOCModulesState();
}

class _SOCModulesState extends State<SOCModules> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Faculties",
        ),
        elevation: 0.0,
        actions: <Widget>[
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
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "images/soc.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              "School Of Computing",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.0),
            Text(
              "Modules",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            // Text(
            //   "xxxxx",
            //   style: TextStyle(
            //     fontSize: 13,
            //     fontWeight: FontWeight.w300,
            //   ),
            // ),
             Container(
              height: 600.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: categories == null?0:categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return Modules(
                    icon: cat['icon'],
                    title: cat['name'],
                    isHome: true,
                  );
                },
              ),
            ),
            SizedBox(height: 150.0),
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments == null ? 0 : comments.length,
              itemBuilder: (BuildContext context, int index) {
                Map comment = comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage(
                      "${comment['img']}",
                    ),
                  ),
                  title: Text("${comment['name']}"),
                  subtitle: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          
                          SizedBox(width: 6.0),
                          Text(
                            "February 14, 2020",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        "${comment["comment"]}",
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 50.0,
      //   child: RaisedButton(
      //     child: Text(
      //       "ADD TO CART",
      //       style: TextStyle(
      //         color: Colors.white,
      //       ),
      //     ),
      //     color: Theme.of(context).accentColor,
      //     onPressed: () {},
      //   ),
      // ),
    );
  }
}
