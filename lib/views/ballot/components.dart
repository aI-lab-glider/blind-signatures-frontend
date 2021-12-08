import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/core/ring.dart';
import 'package:test_app/core/rsa.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/data/constants.dart' as constants;

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
  final String? chosenOption;
  final int pollID;

  const SubmitButton(this.chosenOption, this.pollID);

  Future<void> _submitVote(BuildContext context) async {
    print("Sending vote."); // TODO: signing and sending logic
    if (chosenOption == null ) {
      final snackBar = SnackBar(content: Text('Hmm... It seems that you did not choose an option. Try again, please'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    http.Response? response;
    try {
      response = await signMessage(chosenOption);
    } catch (e) {
      Future.delayed(Duration(milliseconds: 100), () {signMessage(chosenOption);});
    }
    if (response!.statusCode == 200) {
        final snackBar = SnackBar(content: Text('Thank you for your vote!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    else {
      final snackBar = SnackBar(content: Text('Something went wrong when sending your vote. Please, try again later.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pushNamed(context, '/polls');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _submitVote(context),
        child: const Text("Submit")
    );
  }

  Future<http.Response> signMessage(String? chosenOption) async {
    final pair = generateRSAkeyPair(exampleSecureRandom());
    final public = pair.publicKey;
    final private = pair.privateKey;
    var publicKeys = publicKeysExample();
    final myKeyIndex = new Random().nextInt(8) + 1;
    publicKeys.insert(myKeyIndex, public.modulus!);
    Ring ring = Ring(publicKeys);

    var message = ring.sign(createMessage(chosenOption!), myKeyIndex, private.privateExponent!);
    print("Sending message:\n${message}");

    return await sendMessage(message.toString());
  }

  String createMessage(String chosenOption) {
    return '{"pollID": "${pollID}", "chosen_option": "${chosenOption}"}';
  }

  Future<http.Response> sendMessage(String message) {
    return http.post(
      Uri.parse(constants.verifyURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'pollID': pollID,
        'message': message,
      }),
    );
  }
}

class Ballot extends StatefulWidget {
  final int pollID;
  final List<String> options;

  Ballot(this.options, this.pollID);

  @override
  State<StatefulWidget> createState() => _BallotState(options, pollID);
}

class _BallotState extends State<Ballot> {
  final int pollID;
  final List<String> options;
  String? _chosenOption;

  _BallotState(this.options, this.pollID);

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
        children: [
          Container(
              child: Column(children: _radioListTilesForOptions(options))
          ),
          SubmitButton(_chosenOption, pollID)
        ]
    );
  }
}