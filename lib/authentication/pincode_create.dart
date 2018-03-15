import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PinCodeCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create Pin"),
      ),
      body: new Center(
          child: new Column(
        children: <Widget>[
          new Container(height: 20.0),
          new Text(
            'Enter your Pin Code',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('1'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('2'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('3'),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('4'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('5'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('6'),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('7'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('8'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('9'),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text(''),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text('0'),
                        onPressed: null,
                      ),
                    ),
                    new Expanded(
                      child: new RaisedButton(
                        child: new Text(''),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      )
      ),
    );
  }
}
