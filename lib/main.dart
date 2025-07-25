import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/rotas.dart';

import 'package:hellofarmer/Providers/loja_provider.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Services/notificacoes.dart';
import 'package:hellofarmer/firebase_options.dart';
// import 'package:hellofarmer/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('pt'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await inicializarNotificacoes();
  await solicitarPermissoesNotificacoes();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (_, Locale currentLocale, _) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => LojaProvider()),
                ChangeNotifierProvider(create: (_) => UtilizadorProvider()),
              ],
              child: MaterialApp(
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: currentMode,

                locale: currentLocale,
                // localizationsDelegates: const [
                //   AppLocalizations.delegate,
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],

                // supportedLocales: const [
                //   Locale('en'),
                //   Locale('pt'),
                // ],

                routes: Rotas.rotas,
                initialRoute: Rotas.splash,
              ),
            );
          },
        );
      },
    );
  }
}
