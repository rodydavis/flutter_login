import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    this.name,
    this.hintText,
    this.onEmpty,
    this.obscureText,
    this.textInputType,
    this.icon,
    this.validateFunction,
    this.onSaved,
    this.iconColor,
    this.textFieldColor,
  });

  final IconData icon;
  final String hintText;
  final TextInputType textInputType;
  final Color textFieldColor, iconColor;
  final bool obscureText;
  final VoidCallback validateFunction;
  final ValueChanged<String> onSaved;
  final String onEmpty;
  final String name;

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
            onSaved: onSaved,
            obscureText: obscureText,
            keyboardType: textInputType,
          ),
        ),
      ),
    ));
  }
}
