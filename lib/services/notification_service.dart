import 'package:firebase_messaging/firebase_messaging.dart';

/// Servicio para gestionar las notificaciones push mediante Firebase Cloud Messaging (FCM).
class NotificationService {
  /// Instancia de Firebase Messaging utilizada para suscribirse y cancelar suscripción a notificaciones.
  static final _messaging = FirebaseMessaging.instance;

  /// Solicita permiso de notificaciones y suscribe al usuario al tema 'all_users'.
  /// Esto permite recibir notificaciones enviadas a todos los usuarios de la aplicación.
  static Future<void> subscribeToNotifications() async {
    await _messaging.requestPermission(); // Solicita permiso de notificaciones al usuario.
    await _messaging.subscribeToTopic('all_users'); // Suscribe al usuario al tema general de notificaciones.
  }

  /// Cancela la suscripción a las notificaciones del tema 'all_users'.
  /// Esto impide que el usuario reciba futuras notificaciones globales.
  static Future<void> unsubscribeFromNotifications() async {
    await _messaging.unsubscribeFromTopic('all_users');
  }
}