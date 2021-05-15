import 'package:flutter/material.dart';
import 'package:community_nus/settings/const.dart';
import 'package:community_nus/settings/discussionForumItems.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Discussion Forum",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
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
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Top Threads",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          //The list below
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: disussionForum == null ? 0 : disussionForum.length,
            itemBuilder: (BuildContext context, int index) {
              Map thread = disussionForum[index];
              return ListTile(
                title: Text(
                  "${thread['title']}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Wrap(
                    // spacing: 12,
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.grey.shade300, // button color
                          child: InkWell(
                            splashColor: Colors.green, // inkwell color
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                                size: 25,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.grey.shade300, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ]),
                trailing: Icon(
                  Icons.chat_bubble,
                  color: Colors.black,
                  size: 20,
                ),
                subtitle: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "${thread['threads']}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {},
              );
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
