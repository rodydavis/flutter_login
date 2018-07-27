import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/globals.dart' as globals;
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lockedscreen/home.dart';
import 'lockedscreen/settings.dart';
import 'signin/auth_service.dart';
import 'signin/changes.dart' as changes;
import 'signin/newaccount.dart';
import 'signin/signin.dart';

AuthService appAuth = new AuthService();

void main() async {
  var prefs = await SharedPreferences.getInstance();

  Widget _login = LoginPage(prefs: prefs);
  Widget _home = Home();
  // Set default home.
  Widget _defaultHome = _login;

  globals.isDarkTheme = prefs.getBool('isDarkTheme') ?? false;

  // Set Defaults
  prefs.setBool('isDarkTheme', globals.isDarkTheme);

  bool _bioAvaliable = await appAuth.biometricsAvaliable();
  bool _ready = await appAuth.avaliable();
  bool _result = await appAuth.login();

  if (_ready &&
      _result &&
      (!_bioAvaliable || _bioAvaliable && await appAuth.biometrics())) {
    _defaultHome = _home;
  }

  runApp(DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
            primarySwatch: Colors.blue,
            primaryColorBrightness:
                globals.isDarkTheme ? Brightness.dark : Brightness.light,
            brightness: brightness,
          ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Login',
          theme: theme,
          home: WhatsNewPage(
            home: _defaultHome,
            showOnVersionChange: true,
            title: Text(
              "What's New",
              textScaleFactor: globals.textScaleFactor,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            buttonText: Text(
              'Continue',
              textScaleFactor: globals.textScaleFactor,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            items: changes.Updates.changelog(context),
          ),
          routes: <String, WidgetBuilder>{
            "/login": (BuildContext context) => _login,
            "/menu": (BuildContext context) => _home,
            "/home": (BuildContext context) => _home,
            "/settings": (BuildContext context) => SettingsPage(prefs: prefs),
            "/create": (BuildContext context) => CreateAccount(prefs: prefs),
          },
        );
      }));
}
