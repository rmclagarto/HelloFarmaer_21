import 'package:flutter/material.dart';

class PaletaCores {
  // static const Color corPrimaria = Color(0xFF2A815E);
  // static const Color corSecundaria = Color(0xFF005376);
  // static const Color corDoCartao = Colors.white;


  static Color corPrimaria(BuildContext context) {
    return Theme.of(context).brightness != Brightness.dark
    ? Color(0xFF2A815E)
    : Colors.teal;
  }


  static Color corSecundaria(BuildContext context){
    return Theme.of(context).brightness != Brightness.dark
    ? Color(0xFF005376)
    : Color(0xFF005376);
  }


  static Color textTitle(BuildContext context){
    return Theme.of(context).brightness != Brightness.dark
        ? Colors.grey[600]!
        : Colors.grey[400]!;
  }


  static Color textValue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }



  static Color iconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.tealAccent.shade200
        : Colors.teal;
  }

  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;
  }

  static Color dangerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.red[400]!
        : Colors.red;
  }

}