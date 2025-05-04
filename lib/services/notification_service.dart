import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> subscribeToNotifications() async {
    await _messaging.requestPermission();
    await _messaging.subscribeToTopic('all_users');
  }

  static Future<void> unsubscribeFromNotifications() async {
    await _messaging.unsubscribeFromTopic('all_users');
  }
}