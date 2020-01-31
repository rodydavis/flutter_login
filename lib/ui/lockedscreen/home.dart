import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../app/app_drawer.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final _auth = Provider.of<AuthModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          textScaleFactor: textScaleFactor,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 10.0),
            _auth?.user?.avatar != null
                ? Center(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: DecorationImage(
                          image: NetworkImage(_auth?.user?.avatar),
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
              subtitle: _auth?.user?.id == null
                  ? null
                  : Text(
                      _auth?.user?.id.toString() ?? "",
                    ),
            ),
            ListTile(
              title: Text('First Name'),
              subtitle: _auth?.user?.firstname == null
                  ? null
                  : Text(
                      _auth?.user?.firstname.toString() ?? "",
                    ),
            ),
            ListTile(
              title: Text('Last Name'),
              subtitle: _auth?.user?.lastname == null
                  ? null
                  : Text(
                      _auth?.user?.lastname.toString() ?? "",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
