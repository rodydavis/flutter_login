import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';

// Stateful widget for managing name data
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          textScaleFactor: textScaleFactor,
        ),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: ListBody(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            if (!kIsWeb)
              ListTile(
                leading: Icon(Icons.fingerprint),
                title: Text(
                  'Enable Biometrics',
                  textScaleFactor: textScaleFactor,
                ),
                subtitle: Platform.isIOS
                    ? Text(
                        'TouchID or FaceID',
                        textScaleFactor: textScaleFactor,
                      )
                    : Text(
                        'Fingerprint',
                        textScaleFactor: textScaleFactor,
                      ),
                trailing: Switch.adaptive(
                  onChanged: _auth.handleIsBioSetup,
                  value: _auth.isBioSetup,
                ),
              ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'Stay Logged In',
                textScaleFactor: textScaleFactor,
              ),
              subtitle: Text(
                'Logout from the Main Menu',
                textScaleFactor: textScaleFactor,
              ),
              trailing: Switch.adaptive(
                onChanged: _auth.handleStayLoggedIn,
                value: _auth.stayLoggedIn,
              ),
            ),
            Divider(height: 20.0),
            DarkModeSwitch(),
            TrueBlackSwitch(),
            CustomThemeSwitch(),
            PrimaryColorPicker(),
            AccentColorPicker(),
            DarkAccentColorPicker(),
            Divider(height: 20.0),
          ],
        ),
      )),
    );
  }
}
