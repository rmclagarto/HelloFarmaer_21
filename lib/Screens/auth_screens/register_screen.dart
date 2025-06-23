import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Core/image_assets.dart';
import 'package:projeto_cm/Widgets/auth_widgets/forms/register_from.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  void _handleRegister(String email, String password, String comfirmPassword){
    debugPrint('Email: $email, Password: $password Comfirm-Password: $comfirmPassword');
  }

  Widget _buildLogoHeaderImage() {
    return Center(
      child: Image(
        image: AssetImage(ImageAssets.logotipo),
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Padding(padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: <Widget> [
          _buildLogoHeaderImage(),
            Expanded(
              child: Center(
                child: RegisterFrom(
                  onRegister: _handleRegister,
                ),
              ),
            ),
        ],
      ),),
    );
  }
}