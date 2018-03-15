import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'home.dart';

class PinCodeVerify extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pin Code"),
      ),
      body: new Center(
          child: new Column(
        children: <Widget>[
          new Container(height: 20.0),
          new Text(
            'Enter your Pin Code',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          new GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            crossAxisCount: 2,
            children: <Widget>[
              const Text('He\'d have you all unravel at the'),
              const Text('Heed not the rabble'),
              const Text('Sound of screams but the'),
              const Text('Who scream'),
              const Text('Revolution is coming...'),
              const Text('Revolution, they...'),
            ],
          ),
          new Container(height: 20.0),
          new RaisedButton(
            onPressed: () {
              // Navigate back to first screen when tapped!
              Navigator.pop(context);
            },
            child: new Text('Go back!'),
          ),
        ],
      )),
    );
  }
}

class AuthVerify extends StatefulWidget {
  @override
  _AuthVerifyState createState() => new _AuthVerifyState();
}

class _AuthVerifyState extends State<AuthVerify> {
  String _authorized = 'Not Authorized';

  Future<Null> _authenticate() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
    if (_authorized.contains("Authorized")) {
      Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new Home()), //When Authorized Navigate to the next screen
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text('Current State: $_authorized\n'),
                new RaisedButton(
                  child: const Text('Authenticate'),
                  onPressed: _authenticate,
                )
              ])),
    ));
  }
}