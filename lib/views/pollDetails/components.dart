import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PollDescription extends StatelessWidget {

  const PollDescription(this.pollName);

  final String pollName;

  String _getDescriptionByName(String name) {
    var randomNouns = nouns.take(10);
    return "${randomNouns.join(" ")} $name";
  }

  @override
  Widget build(BuildContext context) => Text(
      _getDescriptionByName(pollName),
      textAlign: TextAlign.center
  );
}

class StartButton extends StatelessWidget {
  const StartButton(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              '/ballot',
              arguments: nouns.elementAt(index)
          );
        },
        child: Text('Start!'),
      ),
    );
  }

}