import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unipaz/firebase_options.dart';
import 'package:unipaz/home_page.dart';
import 'package:unipaz/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
      onUnknownRoute: (settings) {
        // Manejo de rutas desconocidas
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      },
    );
  }
}
