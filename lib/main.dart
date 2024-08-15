import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unipaz/firebase_options.dart';
import 'package:unipaz/selectoption.dart';
import 'package:unipaz/pages/start_page.dart';
import 'package:unipaz/notifications/notificationsManager.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unipaz/conductor/mapconductor.dart';
import 'package:flutter_background/flutter_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configuración para flutter_background
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "App activa en segundo plano",
    notificationText: "La ubicación está activa en segundo plano.",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'app_icon', defType: 'drawable'),
  );

  bool hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);

  if (!hasPermissions) {
    // Manejar el caso en que no se puedan otorgar los permisos necesarios
    print('No se pudieron otorgar los permisos para la ejecución en segundo plano.');
  }

  // Obtener la preferencia para saber si es el primer lanzamiento
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  // Verificar si el usuario ya está autenticado
  User? currentUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp(isFirstLaunch: isFirstLaunch, currentUser: currentUser));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  final User? currentUser;

  const MyApp({Key? key, required this.isFirstLaunch, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch ? const StartPage() : const SelectOption(),
      onUnknownRoute: (settings) {
        // Manejo de rutas desconocidas
        return MaterialPageRoute(
          builder: (context) => const SelectOption(),
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
