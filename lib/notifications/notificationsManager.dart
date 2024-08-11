import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationsManager(BuildContext context) {
    _initializeNotifications(context);
  }

  Future<void> _initializeNotifications(BuildContext context) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'location_channel', // Identificador único del canal
      'Ubicación Activa', // Nombre del canal
      'Notificación que indica que la ubicación está activa en segundo plano.', // Descripción del canal
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false, // Hace que la notificación no sea persistente
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      // La clave aquí es utilizar `flags` dentro de `PendingIntent`
      fullScreenIntent: true,
      category: 'service',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      title, // Título de la notificación
      message, // Descripción de la notificación
      platformChannelSpecifics,
    );
  }

  Future<void> showLocationActiveNotification() async {
    await showNotification(
      'Ubicación Activa',
      'La ubicación está activa en segundo plano.',
    );
  }

  Future<void> cancelLocationActiveNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
