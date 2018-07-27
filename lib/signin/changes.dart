import 'package:flutter/material.dart';
import 'package:flutter_login/globals.dart' as globals;

class Updates {
  static List<ListTile> changelog(BuildContext context) {
    return <ListTile>[
      ListTile(
        leading: Icon(Icons.color_lens),
        title: Text(
          'Dark Theme',
          textScaleFactor: globals.textScaleFactor,
        ), //Title is the only Required Item
        subtitle: Text(
          'Black and grey theme (Tap to Change)',
          textScaleFactor: globals.textScaleFactor,
        ),
        onTap: () {
          // You Can Navigate to Locations in the App
          Navigator.of(context).pushNamed("/settings");
        },
      ),
      ListTile(
        leading: Icon(Icons.account_box),
        title: Text(
          'Stay Logged In',
          textScaleFactor: globals.textScaleFactor,
        ), //Title is the only Required Item
        subtitle: Text(
          'You can now stay logged in until you logout from the main menu (Tap to Change)',
          textScaleFactor: globals.textScaleFactor,
        ),
        onTap: () {
          // You Can Navigate to Locations in the App
          Navigator.of(context).pushNamed("/settings");
        },
      ),
      ListTile(
        leading: Icon(Icons.fingerprint),
        title: Text(
          'Enhanced Security',
          textScaleFactor: globals.textScaleFactor,
        ), //Title is the only Required Item
        subtitle: Text(
          'Add an extra layer of security by requiring biometrics to login (Tap to Change)',
          textScaleFactor: globals.textScaleFactor,
        ),
        onTap: () {
          // You Can Navigate to Locations in the App
          Navigator.of(context).pushNamed("/settings");
        },
      ),
    ];
  }
}
