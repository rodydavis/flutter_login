import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/globals.dart' as globals;
import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
// import 'forgot.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({this.prefs});

  final SharedPreferences prefs;

  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  String _username, _password;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerUsername, _controllerPassword;

  @override
  initState() {
    _controllerUsername = TextEditingController();
    _controllerPassword = TextEditingController();
    super.initState();
  }

  Future<Null> _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      final snackbar = SnackBar(
        duration: Duration(seconds: 30),
        content: Row(
          children: <Widget>[
            NativeLoadingIndicator(),
            Text("  Creating Account...")
          ],
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);

      appAuth
          .store(_username.toString().toLowerCase().trim(),
              _password.toString().trim())
          .then((onValue) {
        Navigator.pop(context, true);
        _scaffoldKey.currentState.hideCurrentSnackBar();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: globals.isDarkTheme ? null : Colors.white,
        title: Text(
          "Create Account",
          textScaleFactor: globals.textScaleFactor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
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
              title: NativeButton(
                child: Text(
                  'Save',
                  textScaleFactor: globals.textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
                minWidthAndroid: 220.0,
                buttonColor: Colors.blue,
                paddingExternal: const EdgeInsets.all(10.0),
                paddingInternal: const EdgeInsets.all(10.0),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
