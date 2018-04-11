import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  var validateFunction;
  var onSaved;

  String onEmpty;
  String name;

  //passing props in the Constructor.
  //Java like style
  InputField({
    this.name,
    this.hintText,
    this.onEmpty,
    this.obscureText,
    this.textInputType,
    this.icon,
    this.validateFunction,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
      margin: new EdgeInsets.only(bottom: 10.0),
      child: new DecoratedBox(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
            color: Colors.grey[50]),
        child: new Padding(
          padding: EdgeInsets.all(5.0),
          child: new TextFormField(
            decoration: new InputDecoration(
              icon: new Icon(icon),
              labelText: name,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
            ),
            validator: (val) => val.isEmpty ? onEmpty : null,
            onSaved: (val) => onSaved = val,
            obscureText: obscureText,
            keyboardType: textInputType,
          ),
        ),
      ),
    ));
  }
}

class TextButton extends StatelessWidget {
  VoidCallback onPressed;
  String name;

  //passing props in the Constructor.
  //Java like style
  TextButton({
    this.name,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new FlatButton(
      child: new Text(name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold)),
      onPressed: onPressed,
    ));
  }
}
