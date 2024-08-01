import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final BuildContext? _context; // Añade un contexto para el manejo de la navegación

  // Constructor que acepta un contexto opcional
  NotificationsManager([this._context]) {
    _initNotifications();
  }

  void _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true, // Cambiado a true
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<void> _onSelectNotification(String? payload) async {
    // Implementa la lógica cuando se toca la notificación
    if (payload != null && _context != null) {
      Navigator.of(_context!).pushNamed(payload);
    }
  }

  void showNotification(String title, String message, {String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Nombre del Canal',
      'Descripción del Canal',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void showGlobalNotification(String title, String message) {
    FirebaseFirestore.instance.collection('notificaciones_globales').add({
      'title': title,
      'message': message,
    });
  }
}

// Supongamos que inicializas esto en un lugar donde tienes acceso al contexto, como un widget:
final NotificationsManager notificationsManager = NotificationsManager();
