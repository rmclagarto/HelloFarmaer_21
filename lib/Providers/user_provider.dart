import 'package:flutter/widgets.dart';
import 'package:hellofarmer/Model/custom_user.dart';

class UserProvider with ChangeNotifier{
  CustomUser? _user;

  CustomUser? get user => _user;

  void registerUser(CustomUser newUser){

    // query para o Firebase por o newUser na base de dados
    notifyListeners();
  }

  void setUser(CustomUser newUser){
    _user = newUser;
    notifyListeners();
  }


  void logout(){
    _user = null;
    notifyListeners();
  }

}