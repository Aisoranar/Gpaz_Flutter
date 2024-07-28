import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unipaz/firebase_options.dart';
import 'package:unipaz/home_page.dart';
import 'package:unipaz/pages/start_page.dart';
import 'package:unipaz/notifications/notificationsManager.dart'; // Importa el archivo de notificaciones

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      builder: (context, child) {
        return NotificationsProvider(child: child!);
      },
    );
  }
}

class NotificationsProvider extends StatefulWidget {
  final Widget child;

  const NotificationsProvider({required this.child});

  @override
  _NotificationsProviderState createState() => _NotificationsProviderState();
}

class _NotificationsProviderState extends State<NotificationsProvider> {
  late NotificationsManager notificationsManager;

  @override
  void initState() {
    super.initState();
    notificationsManager = NotificationsManager(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
