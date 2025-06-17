import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:mes_citations/services/http_service.dart';
import 'package:mes_citations/models/Citation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialisation de base à appeler dans main()
  static Future<void> init() async {
    tz.initializeTimeZones();
    final paris = tz.getLocation('Europe/Paris');
    tz.setLocalLocation(paris);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  /// Planifie une notification avec une citation venant de l'API
  static Future<void> scheduleDailyCitationNotification({int hour = 9, int minute = 0}) async {
    bool granted = await _requestPermission();
    if (!granted) {
      print('Permission notification refusée, notification non planifiée');
      return;
    }
    print("on a programmé la notif pour $hour:$minute");
    final scheduled = _nextInstanceOfTime(hour, minute);
    print("Notification prévue à : $scheduled");
    Citation? citation = await HttpService.fetchRandomForismaticQuote();

    if (citation == null) return;
    int randomId = Random().nextInt(1000);
    await _notificationsPlugin.zonedSchedule(
      randomId,
      'Citation du jour',
      '"${citation.citation}"\n- ${citation.auteur}',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_citation_channel',
          'Citations Quotidiennes',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
        androidScheduleMode: AndroidScheduleMode.exact,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }


  static Future<bool> _requestPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }
    return true;
  }

  // static Future<void> showTestNotification() async {
  //  await _notificationsPlugin.show(
  //    1,
  //    'Notification test immédiate',
  //    'Si tu vois ça, les notifications fonctionnent',
  //    const NotificationDetails(
  //      android: AndroidNotificationDetails(
  //        'daily_citation_channel',
  //        'Citations Quotidiennes',
  //        importance: Importance.high,
  //        priority: Priority.high,
  //      ),
  //    ),
  //  );
  //}



}
