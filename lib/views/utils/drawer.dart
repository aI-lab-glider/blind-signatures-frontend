import 'package:flutter/material.dart';
import 'package:test_app/data/constants.dart' as constants;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('https://media.istockphoto.com/illustrations/apollo-illustration-id471337771?k=20&m=471337771&s=612x612&w=0&h=wU3sdm1K0zuClEHgYViQQF8seZc-pn8JwHMLrFkWGNs='),
                  fit: BoxFit.fitWidth
              )
            ),
            child: Text("")
          ),
          ListTile(
            title: const Text(constants.pollsList),
            onTap: () {
              Navigator.pushNamed(context, "/polls");
            },
          ),
          ListTile(
            title: const Text(constants.logOut),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushNamed(context, "/profile");
            },
          ),
        ],
      ),
    );
  }

}