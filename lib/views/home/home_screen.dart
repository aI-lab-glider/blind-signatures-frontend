import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/views/utils/drawer.dart';
import '../authentication/login.dart';
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
        child: const Text("Welcome!"),
      ),
      drawer: AppDrawer(),
    );
  }
}