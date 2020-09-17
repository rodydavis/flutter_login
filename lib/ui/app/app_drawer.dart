import 'package:flutter/material.dart';
import 'package:flutter_login/constants.dart';
import 'package:flutter_login/data/models/auth.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthModel>(context, listen: true);

    TextStyle style = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[900]);
    TextStyle styles = TextStyle(
        fontSize: 17, fontWeight: FontWeight.bold, color: Colors.purple[900]);

    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20))),
              accountName: Text(
                _auth.user.firstname + " " + _auth.user.lastname,
                style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textScaleFactor: textScaleFactor,
              ),
              accountEmail: null,
              currentAccountPicture:
                  ClipOval(child: Image.network(_auth?.user?.avatar)),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 20,
                child: ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.purple[900],
                  ),
                  title: Text(
                    "What's New",
                    style: styles,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 20,
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.purple[900],
                  ),
                  title: Text(
                    'Settings',
                    style: styles,
                    textScaleFactor: textScaleFactor,
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/settings");
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 20,
                child: ListTile(
                    leading: Icon(
                      Icons.arrow_back,
                      color: Colors.purple[900],
                    ),
                    title: Text(
                      'Logout',
                      style: styles,
                      textScaleFactor: textScaleFactor,
                    ),
                    onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text("Logout", style: style),
                            content: Text("Do you really want to Logout",
                                style: styles),
                            actions: [
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel')),
                              FlatButton(
                                  onPressed: () {
                                    _auth.logout();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes'))
                            ],
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
