import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/authentication/auth.dart';
import 'package:test_app/views/pollsList/polls.dart';
import '../../data/constants.dart' as Constants;
import '../pollsList/polls.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Constants.appTitle)),
      body: const Center(
        child: PollsScreen(),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(Constants.choose),
            ),
            ListTile(
              title: const Text(Constants.pollsList),
              onTap: () {
                Navigator.pushNamed(context, "/");
              },
            ),
            ListTile(
              title: const Text(Constants.logOut),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())); //TODO: Popup with warning
                Navigator.pushNamed(context, "/profile");
              },
            ),
          ],
        ),
      ),
    );
  }
}