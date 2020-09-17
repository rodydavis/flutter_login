import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../app/app_drawer.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    TextStyle style = TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[900]);
    TextStyle style1 = TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple[900]);
    Color color = Colors.purple[900];

    return WillPopScope(
      onWillPop: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text("Exit", style: style),
                content: Text("Do you really want to Exit", style: style1),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  FlatButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text('Yes'))
                ],
              )),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.purple[900]),
          backgroundColor: Colors.white,
          title: Text(
            "Home",
            style: TextStyle(color: color),
            textScaleFactor: textScaleFactor,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(height: 10.0),
              _auth?.user?.avatar != null
                  ? Center(
                      child: Container(
                          width: double.infinity,
                          height: 120.0,
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ClipOval(
                                  child: Image.network(_auth?.user?.avatar)),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      color: Colors.purple[900],
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Change Photo',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                      onPressed: () {})
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )),
                    )
                  : Container(
                      height: 0.0,
                    ),
              ListTile(
                leading: IconButton(
                    icon: Icon(
                      Icons.create,
                      color: color,
                    ),
                    onPressed: () {}),
                title: Text(
                  'ID',
                  style: style,
                ),
                subtitle: _auth?.user?.id == null
                    ? null
                    : Text(
                        _auth?.user?.id.toString() ?? "",
                        style: style1,
                      ),
              ),
              ListTile(
                shape: Border.all(
                    width: 2.0, color: color, style: BorderStyle.solid),
                leading: IconButton(
                    icon: Icon(
                      Icons.create,
                      color: color,
                    ),
                    onPressed: () {}),
                title: Text(
                  'First Name',
                  style: style,
                ),
                subtitle: _auth?.user?.firstname == null
                    ? null
                    : Text(
                        _auth?.user?.firstname.toString() ?? "",
                        style: style1,
                      ),
              ),
              ListTile(
                leading: IconButton(
                    icon: Icon(
                      Icons.create,
                      color: color,
                    ),
                    onPressed: () {}),
                title: Text(
                  'Last Name',
                  style: style,
                ),
                subtitle: _auth?.user?.lastname == null
                    ? null
                    : Text(
                        _auth?.user?.lastname.toString() ?? "",
                        style: style1,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
