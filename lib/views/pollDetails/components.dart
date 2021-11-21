import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:test_app/data/constants.dart' as constants;


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

class PollStatistics extends StatelessWidget {
  final List<charts.Series<VotesPerOption, int>> seriesList;
  final bool? animate;

  const PollStatistics(this.seriesList, {Key? key, required this.animate}) : super(key: key);

  factory PollStatistics.withSampleData() {
    return PollStatistics(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Poll Statistics", style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
            padding: const EdgeInsets.all(8.0),
            child:  SizedBox(
                          height: 200.0,
                          child: charts.PieChart<int>(
                            seriesList,
                            animate: animate,
                            defaultInteractions: true,
                            defaultRenderer: charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  charts.ArcLabelDecorator(
                                      labelPosition: charts.ArcLabelPosition.auto
                                  )
                                ]
                            ),
                          )
                      )
        ),
        Text("${2+Random().nextInt(98)}% of all users voted."),
      ],
    );
  }

  /// Create one series with random sample data.
  static List<charts.Series<VotesPerOption, int>> _createSampleData() {

    var rng = new Random();

    final data = [
      VotesPerOption(0, rng.nextInt(100)),
      VotesPerOption(1, rng.nextInt(100)),
      VotesPerOption(2, rng.nextInt(100)),
      VotesPerOption(3, rng.nextInt(100)),
    ];

    final overallVotesCount = data.fold(0, (int val, current) => val + current.votesCount);

    return [
      charts.Series<VotesPerOption, int>(
        id: 'Votes',
        domainFn: (VotesPerOption votesCount, _) => votesCount.optionID,
        measureFn: (VotesPerOption votesCount, _) => votesCount.votesCount,
        data: data,
        labelAccessorFn: (VotesPerOption votesCount, _) => '#${votesCount.optionID}: ${(votesCount.votesCount/overallVotesCount*100).toStringAsFixed(0)}%',
      )
    ];
  }
}

/// Sample linear data type.
class VotesPerOption {
  int optionID;
  int votesCount;

  VotesPerOption(this.optionID, this.votesCount);
}