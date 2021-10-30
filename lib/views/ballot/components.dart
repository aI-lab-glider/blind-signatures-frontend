import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  const Question(this.pollName);
  final String pollName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("What of options for $pollName do you choose?")
    );
  }

}

class SubmitButton extends StatelessWidget {
  const SubmitButton();

  void _submitVote() {
    print("Sending vote.");
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _submitVote(),
        child: Text("Submit")
    );
  }
}


class Options extends StatefulWidget {
  Options(this.pollName);

  final String pollName;

  @override
  State<StatefulWidget> createState() => _OptionsState(pollName);
}

class _OptionsState extends State<Options> {
  _OptionsState(this.pollName);
  final String pollName;

  String? _chosenOption;

  List<String> _loadOptionsForPoll(String pollName) {
    return ["Option1", "Option2", "Option3", "Option4"];
  }

  List<RadioListTile> _radioListTilesForOptions(List<String> options) {
    List<RadioListTile> radioTilesList = [];
    for (var option in options) {
      var radioOption = RadioListTile(
        title: Text(option),
        value: option,
        groupValue: _chosenOption,
        onChanged: (String? value) {
          setState(() {
            _chosenOption = value;
          });
        },
      );
      radioTilesList.add(radioOption);
    }
    return radioTilesList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: _radioListTilesForOptions(_loadOptionsForPoll(pollName))
    );
  }
}