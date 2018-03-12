import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Login Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _username;
  var _companycode;
  var _password;

  final TextEditingController _controllerUsername = new TextEditingController();
  final TextEditingController _controllerCompanyCode = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();

  void _loginButton({String name, String pass, String company}) {
    this._username = name;
    this._companycode = company;
    this._password = pass;

    if(_username == "" || _companycode == "" || _password == "") {
      print("Missing Info");
    } else {
      print("Login from Page");
      print(_username);
      print(_companycode);
      print(_password);
    }

  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(

        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              'images/unifylogo.png',
              width: 175.0,
              height: 100.0,
              fit: BoxFit.fitHeight,
            ),
            new Padding(
              padding: new EdgeInsets.all(4.0),
              child:
              new TextField(
                controller: _controllerUsername,
                decoration: new InputDecoration(
                  hintText: 'Username',
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(4.0),
              child:
              new TextField(
                controller: _controllerCompanyCode,
                decoration: new InputDecoration(
                  hintText: 'Unify Domain',
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(4.0),
              child:
              new TextField(
                controller: _controllerPassword,
                decoration: new InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(4.0),
              child: new RaisedButton(
                onPressed: () {
                  _loginButton(name: this._controllerUsername.text,
                      company: this._controllerCompanyCode.text,
                      pass: this._controllerPassword.text
                  );
                },
                child: new Text('LOGIN'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
