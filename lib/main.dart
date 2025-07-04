import 'package:projeto_cm/Services/notification_service.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_cm/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('pt'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initNotifications();
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
            return MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: currentMode,

              locale: currentLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              supportedLocales: const [
                Locale('en'),
                Locale('pt'),
                Locale('es'),
              ],

              routes: Routes.routes,
              initialRoute: Routes.splash,
            );
          },
        );
      },
    );
  }
}
