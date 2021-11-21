import 'package:flutter/material.dart';
import 'package:test_app/data/model/poll.dart';
import 'package:test_app/routes.dart';
import 'data/constants.dart' as Constants;
import 'views/pollsList/polls.dart';
import 'data/data_source.dart' as data;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: Constants.appTitle,
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appTitle)),
      body: const PollsScreen(),
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
                Navigator.pushNamed(context, "/profile");
              },
            ),
          ],
        ),
      ),
    );
  }
}