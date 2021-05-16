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
      padding: EdgeInsets.fromLTRB(5, 0, 5.0, 10),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
