import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unipaz/firebase_options.dart';
import 'package:unipaz/selectoption.dart';
import 'package:unipaz/pages/start_page.dart';
import 'package:unipaz/notifications/notificationsManager.dart'; // Importa el archivo de notificaciones
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
<<<<<<< HEAD

  // Obtener la preferencia para saber si es el primer lanzamiento
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
=======
  
  runApp(const MyApp());
>>>>>>> d47a6b2d3dfe1ac3ef374d001a7a6e592b8abca9
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({Key? key, required this.isFirstLaunch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      home: isFirstLaunch ? StartPage() : SelectOption(),
      onUnknownRoute: (settings) {
        // Manejo de rutas desconocidas
        return MaterialPageRoute(
          builder: (context) => SelectOption(),
=======
      home: const StartPage(),
      onUnknownRoute: (settings) {
        // Manejo de rutas desconocidas
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
>>>>>>> d47a6b2d3dfe1ac3ef374d001a7a6e592b8abca9
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

  const NotificationsProvider({super.key, required this.child});

  @override
  NotificationsProviderState createState() => NotificationsProviderState();
}

class NotificationsProviderState extends State<NotificationsProvider> {
  late NotificationsManager notificationsManager;
  static const platform = MethodChannel('com.example.alarmManager');

  @override
  void initState() {
    super.initState();
    notificationsManager = NotificationsManager(context);
    _setMethodCallHandler();
  }

  void _setMethodCallHandler() {
    platform.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'invokeAlarmManagerCallback':
          // Maneja la llamada del método aquí
          print('AlarmManager callback invoked');
          break;
        default:
          throw MissingPluginException('Método no implementado: ${call.method}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
