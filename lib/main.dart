import 'package:flutter/material.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/lockedscreen/home.dart';
import 'ui/lockedscreen/settings.dart';
import 'ui/signin/newaccount.dart';
import 'ui/signin/signin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeModel _model = ThemeModel();
  final AuthModel _auth = new AuthModel();

  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }
    try {
      _model.loadFromDisk();
    } catch (e) {
      print("Error Loading Theme: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ThemeModel>(
        model: _model,
        child: new ScopedModelDescendant<ThemeModel>(
          builder: (context, child, theme) => ScopedModel<AuthModel>(
                model: _auth,
                child: MaterialApp(
                  theme: theme.theme,
                  home: new ScopedModelDescendant<AuthModel>(
                      builder: (context, child, model) {
                    if (model?.user != null) return Home();
                    return LoginPage();
                  }),
                  routes: <String, WidgetBuilder>{
                    "/login": (BuildContext context) => LoginPage(),
                    "/menu": (BuildContext context) => Home(),
                    "/home": (BuildContext context) => Home(),
                    "/settings": (BuildContext context) => SettingsPage(),
                    "/create": (BuildContext context) => CreateAccount(),
                  },
                ),
              ),
        ));
  }
}
