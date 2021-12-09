import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../user/user.dart';
import '../utils/api.dart';
import '../utils/preferences.dart';


enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthorisationProvider with ChangeNotifier {

  Status _loggedInStatus = Status.notLoggedIn;
  Status _registeredInStatus = Status.notRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;


  Future<Map<String, dynamic>> login(String email, String publicKey) async {
    Map<String, dynamic> result;

    final Map<String, dynamic> loginData = {
      'user': {
        'email': email,
        'publicKey': publicKey
      }
    };

    _loggedInStatus = Status.authenticating;
    notifyListeners();

    Response response = await post(
      AppApi.login as Uri,
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'}, //TODO: login
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.loggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<dynamic> register(String email, String publicKey) async {

    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'publicKey': publicKey,
      }
    };


    _registeredInStatus = Status.registering;
    notifyListeners();

    return await post(AppApi.register as Uri,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    Map<String, Object> result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {

      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

}