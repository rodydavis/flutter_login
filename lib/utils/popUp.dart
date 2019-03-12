import 'package:flutter/material.dart';
import 'package:native_widgets/native_widgets.dart';

void showAlertPopup(BuildContext context, String title, String detail) async {
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
        title: Text(title),
        content: Text(detail),
        actions: <NativeDialogAction>[
          NativeDialogAction(
              text: Text('OK'),
              isDestructive: false,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ));
}
