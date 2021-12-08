import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/constants.dart' as constants;
import 'package:test_app/login/utils/preferences.dart';
import 'package:test_app/login/utils/widgets.dart';

Widget AlertDialogButton(String title, String message, BuildContext context, Function(BuildContext) fun) {
  return longButtons(
    title, () => {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => fun(context),
              child: const Text('OK'),
            ),
          ],
        ),
      )
      }
  );

}

