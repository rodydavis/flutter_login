import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../utils/popUp.dart';

class CreateAccount extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Create Account",
          textScaleFactor: textScaleFactor,
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
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: Text(
                  'Save',
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () async {
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    final snackbar = SnackBar(
                      duration: Duration(seconds: 30),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("  Signing Up...")
                        ],
                      ),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackbar);

                    _auth
                        .login(
                      username: _username.toString().toLowerCase().trim(),
                      password: _password.toString().trim(),
                    )
                        .then((result) async {
                      if (result) {
                        final snackbar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: Row(
                            children: <Widget>[
                              CircularProgressIndicator(),
                              Text("  Signing Up...")
                            ],
                          ),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);

                        await Future.delayed(Duration(seconds: 3));
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        Navigator.pop(context, true);
                      } else {
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        showAlertPopup(context, 'Info', _auth.errorMessage);
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
