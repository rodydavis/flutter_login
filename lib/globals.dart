library globals;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:native_widgets/native_widgets.dart';

import 'lockedscreen/home.dart';
import 'main.dart';
import 'signin/changes.dart' as changes;

//Variables
bool isDarkTheme = false;
bool isLoggedIn = false;
double textScaleFactor = 1.0;
bool isBioSetup = false;
bool logoutFromMenu = false;
bool stayLoggedIn = true;
String errorMessage = "";

String domain = "";
String apiURL = "https://reqres.in/api/users/2";

String id = "0";
String firstname = "Test";
String lastname = "Test";
String avatar =
    "https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg";

enum AlertAction {
  cancel,
  discard,
  disagree,
  agree,
}

User currentUser;

class User {
  final String id, firstname, lastname, avatar;

  String token;

  User({this.token, this.avatar, this.firstname, this.id, this.lastname});

  @override
  String toString() {
    return "$firstname $lastname".toString();
  }
}

class Utility {
  static void showAlertPopup(
      BuildContext context, String title, String detail) async {
    void showDemoDialog<T>({BuildContext context, Widget child}) {
      showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => child,
      );
    }

    return showDemoDialog<Null>(
        context: context,
        child: NativeDialog(
          title: title,
          content: detail,
          actions: <NativeDialogAction>[
            NativeDialogAction(
                text: 'OK',
                isDestructive: false,
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ));
  }

  static Future<String> getData(Map params) async {
    var requestURL = apiURL;
    print(params.toString());
    print("Request URL: " + requestURL);

    var url = requestURL;
    var httpClient = new HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        try {
          var json = await response.transform(utf8.decoder).join();
          result = json;
        } catch (exception) {
          result = 'Error Getting Data';
        }
      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }
    print("Result: " + result);
    return result;
  }

  // Side Menu
  static Widget getMenuBar(BuildContext context) {
    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                currentUser.firstname + " " + currentUser.lastname,
                textScaleFactor: textScaleFactor,
                maxLines: 1,
              ),
              subtitle: Text(
                currentUser.id,
                textScaleFactor: textScaleFactor,
                maxLines: 1,
              ),
              // onTap: () {
              //   Navigator.of(context).popAndPushNamed("/myaccount");
              // },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "What's New",
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WhatsNewPage(
                            home: Home(),
                            showNow: true,
                            title: Text(
                              "What's New",
                              textScaleFactor: textScaleFactor,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            buttonText: Text(
                              'Continue',
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            items: changes.Updates.changelog(context),
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed("/settings");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text(
                'Logout',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                // Login.logout(context);
                appAuth.logout().then((_) =>
                    Navigator.of(context).pushReplacementNamed('/login'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
