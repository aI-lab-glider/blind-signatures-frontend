import 'package:flutter/material.dart';
import 'package:test_app/routes.dart';
import 'package:test_app/views/utils/drawer.dart';
import 'data/constants.dart' as constants;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: constants.appTitle,
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
      appBar: AppBar(title: Text(constants.appTitle)),
      body: const Center(child: const Text("Welcome!")),
      drawer: AppDrawer(),
    );
  }
}