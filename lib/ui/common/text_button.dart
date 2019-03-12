import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  const TextButton({
    this.name,
    this.onPressed,
  });

  final VoidCallback onPressed;
  final String name;

  @override
  Widget build(BuildContext context) {
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
