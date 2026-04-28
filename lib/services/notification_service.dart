import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    if (!kIsWeb) {
      await _messaging.subscribeToTopic('opportunity_matches');
      await _messaging.subscribeToTopic('application_updates');
    }
  }
}
