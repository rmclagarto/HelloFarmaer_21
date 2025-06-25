// import 'package:flutter/material.dart';
// import 'package:projeto_cm/Core/routes.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// final FLutterLocalNotificationsPlugin fLutterLocalNotificationsPlugin = fLutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  

//   const AndroidInitializationSettings androidInit =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initSettings =
//       InitializationSettings(android: androidInit);

//   await flutterLocalNotificationsPlugin.initialize(initSettings);
  
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: Routes.splash,
//       routes: Routes.routes,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.splash,
      routes: Routes.routes,
    );
  }
}
