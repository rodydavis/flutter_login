import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/globals.dart' as globals;
import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:get_version/get_version.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Stateful widget for managing name data
class SettingsPage extends StatefulWidget {
  final SharedPreferences prefs;
  SettingsPage({this.prefs});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

// State for managing fetching name data over HTTP
class _SettingsPageState extends State<SettingsPage> {
  // bool googleMapsInstalled = false;
  // GalleryTheme _galleryTheme = kAllGalleryThemes[0];
  String _projectVersion = 'Unknown';

  @override
  initState() {
    super.initState();
    initPlatformState();
    AppReview.getAppID.then((onValue) {
      print('App ID: ' + onValue);
    });
    bool isSetup = widget.prefs.getBool('isBioSetup');
    bool isDark = widget.prefs.getBool('isDarkTheme');
    bool stayLoggedIn = widget.prefs.getBool('stayLoggedIn');

    setState(() {
      globals.stayLoggedIn = stayLoggedIn == null ? true : stayLoggedIn;
      globals.isBioSetup = isSetup == null ? false : isSetup;
      globals.isDarkTheme = isDark == null ? false : isDark;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  void handelFingerprint(bool value) {
    setState(() {
      globals.isBioSetup = value;
      widget.prefs.setBool('isBioSetup', globals.isBioSetup);
    });
  }

  void handelLoggedIn(bool value) {
    setState(() {
      globals.stayLoggedIn = value;
      widget.prefs.setBool('stayLoggedIn', value);
    });
  }

  void handelTheme(bool value) {
    setState(() {
      globals.isDarkTheme = value;
      globals.isDarkTheme = globals.isDarkTheme;
      widget.prefs.setBool('isDarkTheme', globals.isDarkTheme);
      if (globals.isDarkTheme) {
        DynamicTheme.of(context).setBrightness(Brightness.dark);
      } else {
        DynamicTheme.of(context).setBrightness(Brightness.light);
      }
    });
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.isDarkTheme ? null : Colors.white,
        title: Text(
          "Settings",
          textScaleFactor: globals.textScaleFactor,
        ),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: ListBody(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text(
                'Enable Biometrics',
                textScaleFactor: globals.textScaleFactor,
              ),
              subtitle: Platform.isIOS
                  ? Text(
                      'TouchID or FaceID',
                      textScaleFactor: globals.textScaleFactor,
                    )
                  : Text(
                      'Fingerprint',
                      textScaleFactor: globals.textScaleFactor,
                    ),
              trailing: NativeSwitch(
                onChanged: handelFingerprint,
                value: globals.isBioSetup,
              ),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'Stay Logged In',
                textScaleFactor: globals.textScaleFactor,
              ),
              subtitle: Text(
                'Logout from the Main Menu',
                textScaleFactor: globals.textScaleFactor,
              ),
              trailing: NativeSwitch(
                onChanged: handelLoggedIn,
                value: globals.stayLoggedIn,
              ),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text(
                'Dark Theme',
                textScaleFactor: globals.textScaleFactor,
              ),
              subtitle: Text(
                'Black and Grey Theme',
                textScaleFactor: globals.textScaleFactor,
              ),
              trailing: NativeSwitch(
                onChanged: handelTheme,
                value: globals.isDarkTheme,
              ),
            ),
            Divider(
              height: 20.0,
            ),
            Text("Version: $_projectVersion", textAlign: TextAlign.center,),
          ],
        ),
      )),
    );
  }
}
