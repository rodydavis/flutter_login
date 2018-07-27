import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/globals.dart' as globals;
import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'auth_service.dart';
import 'newaccount.dart';
// import 'forgot.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.prefs});

  final SharedPreferences prefs;

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _status = 'no-action';
  String _username, _password;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerUsername, _controllerPassword;

  @override
  initState() {
    rememberMe = (widget.prefs.getBool('rememberMe') ?? false);
    widget.prefs.setBool('rememberMe', rememberMe); // Default
    String tempUsername = "";
    if (rememberMe) {
      tempUsername = widget.prefs.getString('username') ?? "";
    }
    _controllerUsername = TextEditingController(text: tempUsername);
    _controllerPassword = TextEditingController();
    if (!globals.logoutFromMenu) if (globals.isBioSetup) loginWithBio();
    globals.logoutFromMenu = false;

    super.initState();
    print(_status);
  }

  bool rememberMe = false;
  void handelRememberme(bool value) {
    setState(() {
      rememberMe = value;
      widget.prefs.setBool('rememberMe', value);
    });
  }

  Future<Null> _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      final snackbar = SnackBar(
        duration: Duration(seconds: 30),
        content: Row(
          children: <Widget>[NativeLoadingIndicator(), Text("  Logging In...")],
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);

      setState(() => this._status = 'loading');
      appAuth
          .store(_username.toString().toLowerCase().trim(),
              _password.toString().trim())
          .then((onValue) {
        appAuth.login().then((result) {
          if (result) {
            // Navigator.of(context).pushReplacementNamed('/home');
            Login.showTouchID(context); //Show Touch ID Once After Install
          } else {
            setState(() => this._status = 'rejected');
            globals.Utility
                .showAlertPopup(context, 'Info', globals.errorMessage);
          }
          if (!globals.isBioSetup) {
            setState(() {
              print('Bio No Longer Setup');
            });
          }
          _scaffoldKey.currentState.hideCurrentSnackBar();
        });
      });
    }
  }

  void loginWithBio() {
    appAuth.biometrics().then((pass) {
      if (pass) {
        appAuth.login().then((result) {
          if (result) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            setState(() => this._status = 'rejected');
            globals.Utility
                .showAlertPopup(context, 'Info', globals.errorMessage);
          }
        });
      } else {
        setState(() {
          globals.Utility.showAlertPopup(
              context, 'Info', 'Login Failed, Please Try Again');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
            SizedBox(
              height: 220.0,
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.person,
                    size: 175.0,
                  )),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) =>
                          val.length < 1 ? 'Username Required' : null,
                      onSaved: (val) => _username = val,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _controllerUsername,
                      autocorrect: false,
                      style: TextStyle(
                          color: globals.isDarkTheme
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (val) =>
                          val.length < 1 ? 'Password Required' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      style: TextStyle(
                          color: globals.isDarkTheme
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Remember Me',
                textScaleFactor: globals.textScaleFactor,
              ),
              trailing: NativeSwitch(
                onChanged: handelRememberme,
                value: rememberMe,
              ),
            ),
            ListTile(
              title: NativeButton(
                child: Text(
                  'Login',
                  textScaleFactor: globals.textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
                minWidthAndroid: 220.0,
                buttonColor: Colors.blue,
                paddingExternal: const EdgeInsets.all(10.0),
                paddingInternal: const EdgeInsets.all(10.0),
                onPressed: _submit,
              ),
              trailing: !globals.isBioSetup
                  ? null
                  : NativeButton(
                      child: Icon(
                        Icons.fingerprint,
                        color: Colors.white,
                      ),
                      buttonColor: Colors.redAccent[400],
                      paddingExternal: const EdgeInsets.all(10.0),
                      paddingInternal: const EdgeInsets.all(10.0),
                      onPressed: globals.isBioSetup
                          ? loginWithBio
                          : () {
                              globals.Utility.showAlertPopup(context, 'Info',
                                  "Please Enable in Settings after you Login");
                            },
                    ),
            ),
            NativeButton(
              child: Text(
                'Need an Account?',
                textScaleFactor: globals.textScaleFactor,
                style: TextStyle(
                    color: globals.isDarkTheme ? Colors.white : Colors.black),
              ),
              onPressed: () {
                Navigator
                    .push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccount(
                                prefs: widget.prefs,
                              ),
                          fullscreenDialog: true),
                    )
                    .then((success) => success
                        ? globals.Utility.showAlertPopup(
                            context, 'Info', "New Account Created, Login Now.")
                        : null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
