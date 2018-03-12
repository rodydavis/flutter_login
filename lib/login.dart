import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  }) : super(key: key);

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

  EnsureVisibleWhenFocusedState createState() => new EnsureVisibleWhenFocusedState();
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

    if (!widget.focusNode.hasFocus)
      return;

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
  FocusNode _companycodeFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();

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

      //Todo: Get Token
      //Todo: Set Company Code from Domain
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login Example'),
      ),
      body: new Container(
        child: new ListView(
          physics: new NeverScrollableScrollPhysics(),
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
                    'images/unifylogo.png',
                    width: 250.0,
                    height: 170.0,
                    fit: BoxFit.fitWidth,
                  ),
                  new Center(
                    child: new EnsureVisibleWhenFocused(
                      focusNode: _usernameFocusNode,
                      child:
                      new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child:
                        new TextFormField(
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
                      focusNode: _companycodeFocusNode,
                      child:
                      new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child:
                        new TextFormField(
                          focusNode: _companycodeFocusNode,
                          controller: _controllerCompanyCode,
                          decoration: new InputDecoration(
                            labelText: 'Unify Domain',
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(height: 8.0),
                  new Center(
                    child: new EnsureVisibleWhenFocused(
                      focusNode: _passwordFocusNode,
                      child:
                      new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child:
                        new TextFormField(
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
                  new Container(),
                  new RaisedButton(
                    onPressed: () {
                      _loginButton(name: this._controllerUsername.text,
                          company: this._controllerCompanyCode.text,
                          pass: this._controllerPassword.text
                      );
                    },
                    child: new Text('Login'),
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