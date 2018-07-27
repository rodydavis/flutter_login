import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/globals.dart' as globals;
import 'package:local_auth/local_auth.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class AuthService {
  // Login
  Future<bool> login() async {
    var uuid = new Uuid();
    var prefs = await SharedPreferences.getInstance();
    String _username = prefs.getString('username');
    String _password = prefs.getString('password');
    if (_username == null || _password == null) return false;

    // Get New Token
    var mapData = Map();
    mapData["username"] = "" + _username;
    mapData["password"] = "" + _password;

    String _result = await globals.Utility.getData(null);
    String _avatar, _firstName, _lastName, _id, _token;
    try {
      Map decoded = json.decode(_result);

      if (decoded['data']['Error'] != null) {
        globals.errorMessage = decoded['data']['Description'].toString();
        return false;
      }
      _avatar = decoded['data']['avatar'].toString();
      _firstName = decoded['data']['first_name'].toString();
      _lastName = decoded['data']['last_name'].toString();
      _id = decoded['data']['id'].toString();
      _token = uuid.v4().toString();

      globals.currentUser = globals.User(
        avatar: _avatar,
        firstname: _firstName,
        lastname: _lastName,
        id: _id,
        token: _token,
      );
    } catch (exception) {
      print("Error Decoding Data (login): $exception");
    }

    bool validToken = _token == null || _token.isEmpty ? false : true;
    if (!validToken) return false;
    return validToken;
  }

  // Logout
  Future<void> logout() async {
    globals.currentUser?.token = "";
    globals.logoutFromMenu = true;
    globals.Utility.getData(null);
    return;
  }

  Future<String> getToken() async {
    globals.currentUser?.token = "";
    String token = "";
    var prefs = await SharedPreferences.getInstance();
    String _username = prefs.getString('username');
    String _password = prefs.getString('password');
    if (_username == null || _password == null) return "";

    // Get New Token
    var mapData = Map();
    mapData["username"] = "" + _username;
    mapData["password"] = "" + _password;
    String _result = await globals.Utility.getData(null);
    try {
      Map decoded = json.decode(_result);
      if (decoded.toString().toLowerCase().contains('error')) {
        globals.errorMessage = "" + decoded[0]['Description'].toString();
        return "";
      } else {
        token = decoded['data']['Token'].toString() ?? "";
      }
    } catch (exception) {
      print("Error Decoding Data (token): $exception");
    }
    globals.currentUser?.token = token;

    return token;
  }

  Future<bool> checkToken() async {
    String response = await globals.Utility.getData(null);
    print("Response: " + response);
    try {
      if (response.contains('Invalid Token')) {
        return false;
      } else if (response.contains('Failed')) {
        return false;
      }
    } catch (exception) {
      print("Error Decoding Data, Token: $exception");
    }
    return true;
  }

  Future<void> store(String username, String password) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    return;
  }

  Future<void> reset() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('password', null);
    return;
  }

  Future<bool> avaliable() async {
    var prefs = await SharedPreferences.getInstance();
    bool stayLoggedin = prefs.getBool('stayLoggedIn');
    if (stayLoggedin == null) stayLoggedin = true; //Default
    prefs.setBool('stayLoggedIn', stayLoggedin);
    return stayLoggedin;
  }

  Future<bool> biometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    return authenticated;
  }

  Future setUpBiometrics(bool enabled) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBioSetup', enabled);
    globals.isBioSetup = enabled;
  }

  Future<bool> biometricsAvaliable() async {
    var prefs = await SharedPreferences.getInstance();
    bool isAvaliable = prefs.getBool('isBioSetup');
    if (isAvaliable == null) isAvaliable = false;
    globals.isBioSetup = isAvaliable;
    return isAvaliable;
  }
}

class Login {
  static bool checkLoginToken(String response) {
    print("Response: " + response);
    try {
      if (response.contains('Invalid Token')) {
        return false;
      } else if (response.contains('Failed')) {
        return false;
      }
    } catch (exception) {
      print("Error Decoding Data, Token: $exception");
    }
    return true;
  }

  static Future showTouchID(BuildContext context) async {
    String _platformBio = Platform.isIOS ? "TouchID or FaceID" : "Fingerprint";
    var prefs = await SharedPreferences.getInstance();
    bool _showTouchID = prefs.getBool('showBio');
    _showTouchID = _showTouchID == null ? true : _showTouchID;
    if (_showTouchID && !globals.isBioSetup) {
      prefs.setBool('showBio', false);
      showDemoDialog<globals.AlertAction>(
          context: context,
          child: NativeDialog(
            title: 'Info',
            content:
                'Would you like to enable $_platformBio for enhanced security? \n\nYou can change this later in settings.',
            actions: <NativeDialogAction>[
              NativeDialogAction(
                  text: 'Enable',
                  isDestructive: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    await setUpBio(true);
                    // showWhatsNew(context);
                    Navigator.of(context).pushNamed("/home");
                  }),
              NativeDialogAction(
                  text: 'Cancel',
                  isDestructive: false,
                  onPressed: () async {
                    Navigator.pop(context);
                    await setUpBio(false);
                    // showWhatsNew(context);
                    Navigator.of(context).pushNamed("/home");
                  }),
            ],
          ));
    } else {
      prefs.setBool('showBio', false);
      // showWhatsNew(context);
      Navigator.of(context).pushNamed("/home");
    }
  }

  static Future<bool> getNewToken() async {
    bool isValid = await appAuth.login();
    return isValid;
  }

  static void showErrorLogin(BuildContext context) {
    print("Invalid Token!");
    globals.currentUser?.token = "";
    globals.isBioSetup = false;
    globals.Utility.showAlertPopup(context, "Info",
        "Please Try Logging In Again!\n" + globals.errorMessage);
    setUpBio(globals.isBioSetup);
  }

  static Future setUpBio(bool enabled) async {
    appAuth.setUpBiometrics(enabled);
  }

  static void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
