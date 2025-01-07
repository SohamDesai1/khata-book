import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/providers/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

final notificationRepoProvider = Provider<NotificationRepo>((ref) {
  return NotificationRepo(ref);
});

class NotificationRepo {
  final ProviderRef ref;

  NotificationRepo(this.ref);

  Future<void> updateFcmToken() async {
    final user = ref.read(selectedUserProvider);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('User: $user');
    debugPrint('FCM Token: $fcmToken');

    if (user != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .upsert({'fcm_token': fcmToken, 'username': user}).select();
      debugPrint('Supabase Response: $response');
    }
  }

  Future<void> sendPushNotification(
      String token, String title, String body) async {
        
      }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'general_notifications',
      'General Notifications',
      channelDescription: 'This channel is used for default notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }
}
