import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// State for managing fetching name data over HTTP
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.isDarkTheme ? null : Colors.white,
        title: Text(
          "Home",
          textScaleFactor: globals.textScaleFactor,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      drawer: globals.Utility.getMenuBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 10.0),
            globals.currentUser?.avatar != null
                ? Center(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: DecorationImage(
                          image: NetworkImage(globals.currentUser?.avatar),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(60.0)),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 0.0,
                  ),
            ListTile(
              title: Text('ID'),
              subtitle: globals.currentUser?.id == null
                  ? null
                  : Text(
                      globals.currentUser?.id.toString() ?? "",
                    ),
            ),
            ListTile(
              title: Text('First Name'),
              subtitle: globals.currentUser?.firstname == null
                  ? null
                  : Text(
                      globals.currentUser?.firstname.toString() ?? "",
                    ),
            ),
            ListTile(
              title: Text('Last Name'),
              subtitle: globals.currentUser?.lastname == null
                  ? null
                  : Text(
                      globals.currentUser?.lastname.toString() ?? "",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
