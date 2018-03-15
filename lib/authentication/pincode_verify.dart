import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/globals.dart' as globals;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_login/lockedscreen/home.dart';
import 'dart:convert';

class PinCodeVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Verify Pin"),
        ),
        body: new GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20.0),
          crossAxisSpacing: 10.0,
          crossAxisCount: 3,
          children: <Widget>[
            const Text(
              '',
              textAlign: TextAlign.center,
            ),
            const Text(
              '',
              textAlign: TextAlign.center,
            ),
            const Text(
              '',
              textAlign: TextAlign.center,
            ),
            const Text(
              '1',
              textAlign: TextAlign.center,
            ),
            const Text(
              '2',
              textAlign: TextAlign.center,
            ),
            const Text(
              '3',
              textAlign: TextAlign.center,
            ),
            const Text(
              '4',
              textAlign: TextAlign.center,
            ),
            const Text(
              '5',
              textAlign: TextAlign.center,
            ),
            const Text(
              '6',
              textAlign: TextAlign.center,
            ),
            const Text(
              '7',
              textAlign: TextAlign.center,
            ),
            const Text(
              '8',
              textAlign: TextAlign.center,
            ),
            const Text(
              '9',
              textAlign: TextAlign.center,
            ),
            const Text(
              '',
              textAlign: TextAlign.center,
            ),
            const Text(
              '0',
              textAlign: TextAlign.center,
            ),
            const Text(
              '',
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
