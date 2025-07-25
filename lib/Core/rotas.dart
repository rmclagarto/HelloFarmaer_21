import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/utilizador.dart';

import 'package:hellofarmer/Screens/auth_screens/login_tela.dart';
import 'package:hellofarmer/Screens/auth_screens/recuperar_senha_tela.dart';
import 'package:hellofarmer/Screens/auth_screens/registrar_tela.dart';
import 'package:hellofarmer/Screens/home_screen/home_screen.dart';
import 'package:hellofarmer/Screens/my_account_screen.dart';
import 'package:hellofarmer/Screens/setting_screen.dart';
import 'package:hellofarmer/Screens/splash_screen.dart';

class Rotas {
  static const splash = '/splash';
  static const login = '/login';
  static const registrar = '/registrar';
  static const recuperarSenha = '/recuperar-senha';
  static const home = '/home';
  static const storePanel = '/store-panel';
  static const mainStore = '/main-store';
  static const storeDetails = '/store-details';
  static const criarAnuncio = '/publicar-anuncio';
  static const configuracoes = '/configuracoes';
  static const meuPerfil = '/perfil';

  
  static Map<String, WidgetBuilder> get rotas => {
    splash: (context) => const Splash(),
    login: (context) => const LoginTela(),
    registrar: (context) => const RegistrarTela(),
    recuperarSenha: (context) => const RecuperarSenhaTela(),
    home: (context) => const Home(),

    configuracoes: (context) {
      final argumentos =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      return SettingsScreen(
        isDarkTheme: argumentos?['isDarkTheme'] ?? false,
        onThemeChanged: argumentos?['onThemeChanged'] ?? (val) {},
      );
    },

    meuPerfil: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Utilizador) {
        return MeuPerfilTela(utilizador: args);
      } else {
        return const LoginTela(); 
      }
    },
  };
}