import 'package:meta/meta.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;
import 'lockedscreen/home.dart';
import 'authentication/pincode_verify.dart';
import 'authentication/pincode_create.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(new MaterialApp(home: new LoginPage()));
}

class LoginPage extends StatefulWidget {
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _username;
  String _companycode;
  String _password;

  Future<Null> _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _performLogin();
    }
  }

  void _performLogin() {
    // This is just a demo, so no actual login here.
    tryLogin(_username, _password);
    final snackbar = new SnackBar(
      content: new Text('username: $_username, password: $_password'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future<bool> _loginRequest(String username, String password) async {
    String result = "";
//      var mapData = new Map();
//      mapData["username"] = "" + _username;
//      mapData["password"] = "" + _password;
//      String jsonData = JSON.encode(mapData);
//      String encodedParams = Uri.encodeFull(jsonData);
//      encodedParams = encodedParams.replaceAll(new RegExp(':'), '%3A');
//      encodedParams = encodedParams.replaceAll(new RegExp(','), '%2C');
//      encodedParams = encodedParams.replaceAll(new RegExp('@'), '%40');
//      encodedParams = encodedParams.replaceAll(new RegExp('#'), '%23');
//      print("PARAMS: " + jsonData);
//      globals.domain = _companycode;
//      result = await globals.Utility.getData("post", "login", "signin", encodedParams, globals.token);
    result = await globals.Utility.getData("", "", "", "", "");

    //Decode Data
    try {
      Map decoded = JSON.decode(result);
//        for (var item in decoded['data']) {
//          print(item["data"]['id'].toString());
//          print(item["data"]['first_name'].toString());
//          print(item["data"]['last_name'].toString());
//          print(item["data"]['avatar'].toString());
//
//          globals.token = "" + item['id'].toString();
////          globals.error = "" + item['id'].toString();
//        }
      globals.id = decoded["data"]['id'].toString();
      globals.firstname = decoded["data"]['first_name'].toString();
      globals.lastname = decoded["data"]['last_name'].toString();
      globals.avatar = decoded["data"]['avatar'].toString();

      print(globals.id);
      print(globals.firstname);
      print(globals.lastname);
      print(globals.avatar);

      globals.token = globals.id;
    } catch (exception) {
      print("Error Decoding Data");
      return false;
    }
    return true;
  }

  tryLogin(String username, String password) async {
    await _loginRequest(username, password);
    print("Token: " + globals.token + " | Error: " + globals.error);

    if (globals.token != 'null') {
      print("Valid Token!");
      globals.isLoggedIn = true;
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new Home()), //When Authorized Navigate to the next screen
      );
    } else {
      print("Invalid Token!");
      globals.isLoggedIn = false;
      globals.error = "Check Username and Password!";
      globals.Utility.showAlertPopup(
          context, "Info", "Please Try Logging In Again!", globals.error);
    }
  }

  String _authorized = 'Not Authorized';
  Future<Null> goToBiometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });

    if (_authorized.contains('Authorized')) {
      //Todo: Get Saved Username and Password from Shared Preferences or SQLite
      String savedUsername = "Test";
      String savedPassword = "Test";

      tryLogin(savedUsername, savedPassword);
    }
  }

  goToPinCode(bool create) async {
    if (create) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new PinCodeCreate()),
      );
    } else {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new PinCodeVerify()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Login Example'),
      ),
      body: new Container(
        child: new ListView(
          physics: new AlwaysScrollableScrollPhysics(),
          key: new PageStorageKey("Divider 1"),
          children: <Widget>[
            new Container(height: 8.0),
            new Image.asset(
              'images/login_contact.png',
              height: 120.0,
              width: 120.0,
              fit: BoxFit.fitHeight,
            ),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Form(
                key: formKey,
                child: new Column(
                  children: [
                    new TextFormField(
                      decoration: new InputDecoration(labelText: 'Username'),
                      validator: (val) =>
                          val.length < 1 ? 'Username Required' : null,
                      onSaved: (val) => _username = val,
                      obscureText: false,
                    ),
                    new TextFormField(
                      decoration:
                          new InputDecoration(labelText: 'Unify Domain'),
                      validator: (val) =>
                          val.length < 1 ? 'Unify Domain Required' : null,
                      onSaved: (val) => _companycode = val,
                      obscureText: false,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(labelText: 'Password'),
                      validator: (val) =>
                          val.length < 1 ? 'Password Required' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                    ),
                    new Container(height: 40.0),
                    new RaisedButton(
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          duration: new Duration(seconds: 10),
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Signing-In...")
                            ],
                          ),
                        ));
                        _submit().whenComplete(
                          () => _scaffoldKey.currentState.hideCurrentSnackBar(),
                        );
                      },
                      child: new Text('Login'),
                    ),
                    new Container(height: 20.0),
                    new RaisedButton(
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          duration: new Duration(seconds: 10),
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Signing-In...")
                            ],
                          ),
                        ));
                        goToBiometrics().whenComplete(
                          () => _scaffoldKey.currentState.hideCurrentSnackBar(),
                        );
                      },
                      child: new Text('Authenticate'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
