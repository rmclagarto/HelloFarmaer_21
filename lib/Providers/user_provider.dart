import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/custom_user.dart';

class UserProvider with ChangeNotifier {
  CustomUser? _user;

  CustomUser? get user => _user;

  void setUser(CustomUser user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(CustomUser updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
