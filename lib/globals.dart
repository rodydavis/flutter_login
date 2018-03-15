library globals;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

//Variables
bool isLoggedIn = false;
String token = "";
String domain = "";
String apiURL = "https://reqres.in/api/users/2";
String error = "";

String id = "0";
String firstname = "Test";
String lastname = "Test";
String avatar = "https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg";

class Utility {

  static Future<Null> showAlertPopup(BuildContext context, String title, String detail1, String detail2) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text(title),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(detail1),
              new Text(detail2),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Done'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  static Future<String> getData(String calltypeParm, String modParm, String actionParm, String paramsParm, String fooParm) async {
    var requestURL = apiURL;
//    requestURL = requestURL + "calltype=" + calltypeParm;
//    requestURL = requestURL + "&mod=" + modParm;
//    requestURL = requestURL + "&?action=" + actionParm;
//    requestURL = requestURL + "&?param=" + paramsParm;
//    requestURL = requestURL + "&?foo=" + fooParm;
    print("Request URL: " + requestURL);

    var url = requestURL;
    var httpClient = new HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        try {
          var json = await response.transform(UTF8.decoder).join();
          result = json;
        } catch (exception) {
          result = 'Error Getting Data';
        }
      } else {
        result = 'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }
    print("Result: " + result);
    return result;
  }
}