import 'package:flutter/foundation.dart';
import '../../data/model/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(publicKey: '', email: '', userId: 0);

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}