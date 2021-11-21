import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'model/poll.dart';
import 'constants.dart' as constants;

Future<List<Poll>> fetchPolls() async {
  final response = await http.get(
    Uri.parse(constants.fetchPollsURL),
    /*headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },*/
  );
  return compute(parsePolls, response.body);
}

List<Poll> parsePolls(String responseBody) {
  final responseJson = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return responseJson.map<Poll>((item) => Poll.fromJson(item)).toList();
}

Future<Poll> fetchPollDetails({required int id}) async {
  final response = await http.get(
    Uri.parse("${constants.fetchPollsURL}/$id"),
    /*headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },*/
  );
  return compute(parsePollDetails, response.body);
}

Poll parsePollDetails(String responseBody) {
  final responseJson = jsonDecode(responseBody);
  return Poll.fromJson(responseJson);
}