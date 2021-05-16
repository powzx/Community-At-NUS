import 'package:flutter/material.dart';
import 'package:community_nus/screens/notifications.dart';
import 'package:community_nus/settings/my_modules.dart';
import 'package:community_nus/settings/faculties.dart';
import 'package:community_nus/settings/badge.dart';
import 'package:community_nus/settings/home_Faculties.dart';
import 'package:community_nus/settings/home.Module.dart';
import 'package:community_nus/screens/discussionForum.dart';
import 'package:community_nus/settings/discussionForumItems.dart';


class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchControl = new TextEditingController();
  String catie = "Threads";
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
          "Your Modules",
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
            Container(
              height: 70.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return Modules(
                    icon: cat['icon'],
                    title: cat['name'],
                    isHome: false,
                    tap: () {
                      setState(() {
                        catie = "${cat['name']}";
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "$catie",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            Divider(),

          
          Card(
            elevation: 6.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Search..",
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _searchControl,
              ),
            ),
          ),
          SizedBox(height: 10),

          //The list below
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: disussionForum == null ? 0 : disussionForum.length,
            itemBuilder: (BuildContext context, int index) {
              Map thread = disussionForum[index];
              return ListTile(
                // title: Text(
                //   "${thread['title']}" + "\n\n${thread['threads']}\n",
                //   style: TextStyle(
                //     fontSize: 17,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                title: RichText(
                  text: TextSpan(
                      text: "${thread['title']}",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: "\n\n${thread['threads']}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ]),
                ),

                // subtitle: Row(
                //   children: <Widget>[
                //     Flexible(
                //       child: Text(
                //         "${thread['threads']}",
                //         style: TextStyle(
                //           fontSize: 13,
                //           fontWeight: FontWeight.w300,
                //         ),
                //       ),
                //     )
                //   ],
                // ),

                subtitle: Row(
                  children: <Widget>[
                    Flexible(
                      child: Wrap(
                          spacing: 5,
                          direction: Axis.horizontal,
                          verticalDirection: VerticalDirection.up,
                          children: <Widget>[
                            ClipOval(
                              child: Material(
                                color: Colors.grey.shade300, // button color
                                child: InkWell(
                                  splashColor: Colors.green, // inkwell color
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                      size: 22,
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                            Text(
                              "5",
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            ClipOval(
                              child: Material(
                                color: Colors.grey.shade300, // button color
                                child: InkWell(
                                  splashColor: Colors.red, // inkwell color
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                            Text(
                              "50",
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.chat_bubble,
                                color: Colors.grey,
                                size: 30.0,
                              ),
                            )
                          ]),
                    )
                  ],
                ),
                onTap: () {},
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
          SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
