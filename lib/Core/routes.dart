import 'package:flutter/material.dart';
import 'package:projeto_cm/Screens/home_screen/home_screen.dart';
import 'package:projeto_cm/Screens/auth_screens/login_screen.dart';
// import 'package:projeto_cm/Screens/store_screens/main_strore_screen.dart';
import 'package:projeto_cm/Screens/market_screens/main_market_screen.dart';
import 'package:projeto_cm/Screens/ad_screens/publicar_anuncio_screnn.dart';
import 'package:projeto_cm/Screens/auth_screens/recover_password_screen.dart';
import 'package:projeto_cm/Screens/auth_screens/register_screen.dart';
import 'package:projeto_cm/Screens/splash_screen.dart';

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
  
  static const market = '/market';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const Splash(),
    login: (context) => const Login(),
    register: (context) => const RegisterScreen(),
    recoverPassword: (context) => const RecoverPasswordScreen(),
    home: (context) => const Home(),

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

    market: (context) => const MarketScreen(),
  };
}
