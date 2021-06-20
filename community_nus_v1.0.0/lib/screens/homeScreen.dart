import 'package:flutter/material.dart';
import 'package:community_nus/settings/home_Faculties.dart';
import 'package:community_nus/settings/Home_ModulesSelector.dart';
import 'package:community_nus/settings/faculties.dart';
import 'package:community_nus/settings/my_modules.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:community_nus/settings/user_data.dart';
import 'package:community_nus/settings/home_special.dart';

class Home extends StatefulWidget {
  final String uid;

  Home({this.uid});

  @override
  _HomeState createState() => _HomeState(uid: uid);
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final String uid;

  _HomeState({this.uid});

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: RetrieveUserInfo(uid: uid).startRetrieve(),
        builder: (BuildContext context, AsyncSnapshot user) {
          if (user.hasData) {
            List moduleList = List.from(user.data.data()["modules"]);
            int length = moduleList.length;
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    Text(
                      "Welcome, ${user.data.data()["name"]}!",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 20.0),

                    Text(
                      "Your Modules",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.0),

                    Container(
                      height: 100.0,
                      child: moduleList[0] == "nil"
                          ? Card(
                              child: Text(
                                "No modules added",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: length,
                              itemBuilder: (context, index) {
                                //Map cat = categories[index];
                                return Modules(
                                  uid: this.uid,
                                  moduleCode: moduleList[index],
                                  isHome: true,
                                );
                              },
                            ),
                    ),

                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Faculties",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),

                    GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 3),
                      ),
                      itemCount: faculties == null ? 0 : faculties.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map faculty = faculties[index];
                        return Faculties(
                          img: faculty['img'],
                          name: faculty['name'],
                          uid: uid,
                        );
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Trending News",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Special(),
                    // SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
