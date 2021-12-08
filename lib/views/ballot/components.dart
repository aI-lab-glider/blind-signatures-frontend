import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  const QuestionText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(text)
    );
  }

}

class SubmitButton extends StatelessWidget {
  const SubmitButton();

  void _submitVote(BuildContext context) {
    print("Sending vote."); // TODO: signing and sending logic
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _submitVote(context),
        child: const Text("Submit")
    );
  }
}


class Options extends StatefulWidget {
  Options(this.options);

  final List<String> options;

  @override
  State<StatefulWidget> createState() => _OptionsState(options);
}

class _OptionsState extends State<Options> {
  _OptionsState(this.options);
  final List<String> options;

  String? _chosenOption;

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
        children: _radioListTilesForOptions(options)
    );
  }
}