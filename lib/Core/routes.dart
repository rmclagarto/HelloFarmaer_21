
import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Screens/ad_screens/publicar_anuncio_screnn.dart';
import 'package:hellofarmer/Screens/auth_screens/login_screen.dart';
import 'package:hellofarmer/Screens/auth_screens/recover_password_screen.dart';
import 'package:hellofarmer/Screens/auth_screens/register_screen.dart';
import 'package:hellofarmer/Screens/home_screen/home_screen.dart';
import 'package:hellofarmer/Screens/my_account_screen.dart';
import 'package:hellofarmer/Screens/setting_screen.dart';
import 'package:hellofarmer/Screens/splash_screen.dart';





class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const recoverPassword = '/recover-password';
  static const home = '/home';
  static const storePanel = '/store-panel';
  static const mainStore = '/main-store';
  static const storeDetails = '/store-details';
  static const publicarAnuncio = '/publicar-anuncio';
  static const setting = '/settings';
  static const myAccount = '/my-account';

  // static const market = '/market';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const Splash(),
    login: (context) => const Login(),
    register: (context) => const RegisterScreen(),
    recoverPassword: (context) => const RecoverPasswordScreen(),
    home: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CustomUser) {
        return Home(user: args);
      } else {
        return const Login(); // fallback seguro
      }
    },

    // storePanel:
    //     (context) => ChangeNotifierProvider(
    //       create: (context) => LojaProvider(),
    //       child: const StorePanelScreen(), // Use consistent naming
    //     ),

    // mainStore: (context) {
    //   // You need to pass a Store object here, perhaps from route arguments
    //   final loja = ModalRoute.of(context)!.settings.arguments as Store;
    //   return MainStoreScreen(loja: loja);
    // },

    // storeDetails: (context) {
    //   final store = ModalRoute.of(context)!.settings.arguments as Store;
    //   return StoreDetailsScreen(store: store);
    // },
    publicarAnuncio: (context) => const PublicarAnuncioScreen(),

    // market: (context) => const MarketScreen(),
    setting: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      return SettingsScreen(
        isDarkTheme: args?['isDarkTheme'] ?? false,
        onThemeChanged: args?['onThemeChanged'] ?? (val) {},
      );
    },



    myAccount: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CustomUser) {
        return MyAccountScreen(user: args);
      } else {
        return const Login(); // fallback caso não tenha user
      }
    },
  };
}
