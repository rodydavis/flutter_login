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

/// A widget that ensures it is always visible when focused.
class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.curve: Curves.ease,
    this.duration: const Duration(milliseconds: 100),
  })
      : super(key: key);

  /// The node we will monitor to determine if the child is focused
  final FocusNode focusNode;

  /// The child widget that we are wrapping
  final Widget child;

  /// The curve we will use to scroll ourselves into view.
  ///
  /// Defaults to Curves.ease.
  final Curve curve;

  /// The duration we will use to scroll ourselves into view
  ///
  /// Defaults to 100 milliseconds.
  final Duration duration;

  EnsureVisibleWhenFocusedState createState() =>
      new EnsureVisibleWhenFocusedState();
}

class EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_ensureVisible);
  }

  Future<Null> _ensureVisible() async {
    // Wait for the keyboard to come into view
    // TODO: position doesn't seem to notify listeners when metrics change,
    // perhaps a NotificationListener around the scrollable could avoid
    // the need insert a delay here.
    await new Future.delayed(const Duration(milliseconds: 600));

    if (!widget.focusNode.hasFocus) return;

    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    ScrollPosition position = scrollableState.position;
    double alignment;
    if (position.pixels > viewport.getOffsetToReveal(object, 0.0)) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else if (position.pixels < viewport.getOffsetToReveal(object, 1.0)) {
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      // No scrolling is necessary to reveal the child
      return;
    }
    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  Widget build(BuildContext context) => widget.child;
}

class LoginPage extends StatefulWidget {
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  FocusNode _usernameFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();

  var _username;
  var _password;

  final TextEditingController _controllerUsername = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _loginReady(String username, String password) {
    this._username = username;
    this._password = password;

    if (_username == "" || _password == "") {
      print("Missing Info");
      return false;
    } else {
      print("Login from Page");
      print("Username: " + _username);
      print("Password: " + _password);
      return true;
    }
  }

  Future<bool> _loginRequest(String username, String password) async {
    String result = "";
    if (_loginReady(username, password)) {
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
    } else {
      print("Missing Data for Request");
      globals.Utility.showAlertPopup(
          context,
          "Info",
          "Username and Password Required!",
          "(This example will accept anything)");
      return false;
    }
    return true;
  }

  tryLogin(String username, String password) async {
    bool canLogIn = await _loginRequest(username, password);
    print("Token: " + globals.token + " | Error: " + globals.error);

    if (canLogIn) {
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
        new MaterialPageRoute(
            builder: (context) =>
                new PinCodeCreate()),
      );
    } else {
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new PinCodeVerify()),
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
            new Container(
              constraints: new BoxConstraints.expand(height: 640.0),
              decoration: null,
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: 50.0,
                  ),
                  new Image.asset(
                    'images/login_contact.png',
                    width: 250.0,
                    height: 170.0,
                    fit: BoxFit.fitHeight,
                  ),
                  new Center(
                    child: new EnsureVisibleWhenFocused(
                      focusNode: _usernameFocusNode,
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new TextFormField(
                          focusNode: _usernameFocusNode,
                          controller: _controllerUsername,
                          decoration: new InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(height: 8.0),
                  new Center(
                    child: new EnsureVisibleWhenFocused(
                      focusNode: _passwordFocusNode,
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new TextFormField(
                          focusNode: _passwordFocusNode,
                          controller: _controllerPassword,
                          obscureText: true,
                          decoration: new InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(height: 20.0),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: () {
                                _scaffoldKey.currentState
                                    .showSnackBar(new SnackBar(
                                  duration: new Duration(seconds: 10),
                                  content: new Row(
                                    children: <Widget>[
                                      new CircularProgressIndicator(),
                                      new Text("  Signing-In...")
                                    ],
                                  ),
                                ));
                                tryLogin(this._controllerUsername.text,
                                        this._controllerPassword.text)
                                    .whenComplete(
                                  () => _scaffoldKey.currentState
                                      .hideCurrentSnackBar(),
                                );
                              },
                              child: new Text('Login'),
                            ),
                            new Container(height: 20.0),
                            new RaisedButton(
                              onPressed: () {
                                _scaffoldKey.currentState
                                    .showSnackBar(new SnackBar(
                                  duration: new Duration(seconds: 10),
                                  content: new Row(
                                    children: <Widget>[
                                      new CircularProgressIndicator(),
                                      new Text("  Signing-In...")
                                    ],
                                  ),
                                ));
                                goToBiometrics().whenComplete(
                                  () => _scaffoldKey.currentState
                                      .hideCurrentSnackBar(),
                                );
                              },
                              child: new Text('Authenticate'),
                            ),
                          ],
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: () {
                                _scaffoldKey.currentState
                                    .showSnackBar(new SnackBar(
                                  duration: new Duration(seconds: 10),
                                  content: new Row(
                                    children: <Widget>[
                                      new CircularProgressIndicator(),
                                      new Text("  Signing-In...")
                                    ],
                                  ),
                                ));
                                goToPinCode(true).whenComplete(
                                  () => _scaffoldKey.currentState
                                      .hideCurrentSnackBar(),
                                );
                              },
                              child: new Text('Create Pin'),
                            ),
                            new Container(height: 20.0),
                            new RaisedButton(
                              onPressed: () {
                                _scaffoldKey.currentState
                                    .showSnackBar(new SnackBar(
                                  duration: new Duration(seconds: 10),
                                  content: new Row(
                                    children: <Widget>[
                                      new CircularProgressIndicator(),
                                      new Text("  Signing-In...")
                                    ],
                                  ),
                                ));
                                goToPinCode(false).whenComplete(
                                  () => _scaffoldKey.currentState
                                      .hideCurrentSnackBar(),
                                );
                              },
                              child: new Text('Verify Pin'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
