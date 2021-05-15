import 'package:community_nus/modulesSelectionPages/bizModules.dart';
import 'package:community_nus/modulesSelectionPages/socModules.dart';
import 'package:flutter/material.dart';
import 'package:community_nus/screens/modulesChatCategoryFromMainScreen.dart';

class Faculties extends StatefulWidget {
  final String name;
  final String img;

  Faculties({Key key, @required this.name, @required this.img})
      : super(key: key);

  @override
  _FacultiesState createState() => _FacultiesState();
}

class _FacultiesState extends State<Faculties> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return BizModules();
            },
          ),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 2.0),
                  Text(
                    "${widget.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 9,
                    width: MediaQuery.of(context).size.width / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        "${widget.img}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // SizedBox(height: 5),
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
