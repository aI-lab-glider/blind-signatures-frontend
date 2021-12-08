import '../../data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.userId);
    prefs.setString("email", user.email);
    prefs.setString("publicKey", user.publicKey);

    return prefs.commit();
  }

  Future<bool> saveKeys(BigInt public, BigInt private) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("publicKey", public.toString());
    prefs.setString("rivate", private.toString());

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") as int;
    String email = prefs.getString("email") as String;
    String publicKey = prefs.getString("publicKey") as String;

    return User(
        userId: userId,
        email: email,
        publicKey: publicKey);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("email");
    prefs.remove("publicKey");
  }

  Future<String> getPublicKey(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("publicKey") as String;
    return token;
  }
}