import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/constants.dart' as constants;
import 'package:test_app/login/utils/preferences.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(constants.logOut),
              content: const Text(constants.logOutDescription),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => doLogOut(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: Text("Log Out")
        )
    );
  }

  doLogOut(BuildContext context) {
    var prefs = UserPreferences();
    prefs.removeUser();
    Navigator.pushNamed(context, '/login');
  }

}