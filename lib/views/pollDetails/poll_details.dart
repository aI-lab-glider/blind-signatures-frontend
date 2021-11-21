import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/constants.dart' as Constants;

import 'components.dart';

class PollDetailsScreen extends StatelessWidget {
  const PollDetailsScreen(this.index);
  final int index;

  @override
  Widget build(BuildContext context) {
    /*TODO return PollDetailsScreen with a StartButton or PollStatistics
       depending on poll due date and whether the user has voted in this poll.
     */
    if (index % 2 == 0) {
      return Scaffold(
          appBar: AppBar(title: Text(Constants.appTitle)),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PollDescription(nouns.elementAt(index)),
                StartButton(index)
              ]
          )
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(title: Text(Constants.appTitle)),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PollDescription(nouns.elementAt(index)),
                PollStatistics.withSampleData()
              ]
          )
      );
    }
  }
}


