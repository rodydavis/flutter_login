import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/globals.dart' as globals;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Center(
          child: new Column(
        children: <Widget>[
          new Container(height: 20.0),
          new CircleAvatar(
            radius: 60.0,
            backgroundImage: new NetworkImage(globals.avatar),
          ),
          new Container(height: 10.0),
          new Text(
            'ID: ' + globals.id,
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          new Container(height: 10.0),
          new Text(
            'First Name: ' + globals.firstname,
            style: new TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          new Container(height: 10.0),
          new Text(
            'Last Name: ' + globals.lastname,
            style: new TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ],
      )),
    );
  }
}
