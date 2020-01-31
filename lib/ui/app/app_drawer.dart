import 'package:flutter/material.dart';
import 'package:flutter_login/constants.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);
    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                _auth.user.firstname + " " + _auth.user.lastname,
                textScaleFactor: textScaleFactor,
                maxLines: 1,
              ),
              subtitle: Text(
                _auth.user.id.toString(),
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
                    builder: (context) => WhatsNewPage.changelog(
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
                    ),
                    fullscreenDialog: true,
                  ),
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
              onTap: () => _auth.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
