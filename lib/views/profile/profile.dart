import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/constants.dart' as constants;
import 'package:test_app/data/model/user.dart';
import 'package:test_app/login/providers/authorisation.dart';
import 'package:test_app/login/utils/preferences.dart';

import 'components.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(constants.appTitle)),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child:
          Column(
            children: [
              Spacer(),
              AlertDialogButton(constants.logOut, constants.logOutDescription, context, doLogOut),
              SizedBox(height: 5.0),
              AlertDialogButton(constants.deleteProfile, constants.deleteProfileDescription, context, doDeleteProfile),
              Spacer()
            ]
          )
      ),
    );
  }

  void doLogOut(BuildContext context) {
    var prefs = UserPreferences();
    prefs.removeUser();
    Navigator.pushNamed(context, '/login');
  }

  Future<void> doDeleteProfile(BuildContext context) async {
    var prefs = UserPreferences();
    User user = await prefs.getUser();
    AuthorisationProvider().deleteUser(user);
    Navigator.pushNamed(context, '/login');
  }
}