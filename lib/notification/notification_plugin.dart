import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPlugin {
  static ensureInitialized() {
    if (_instance == null) {
      _getInstance();
    }
  }

  factory NotificationPlugin.getInstance() => _getInstance();

  static NotificationPlugin _instance;

  static _getInstance() {
    if (_instance == null) {
      _instance = NotificationPlugin._();
    }
    return _instance;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationPlugin._() {
    init();
  }

  void init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestPermission();
    }
    initializePlatformSpecifics();
  }

  void _requestPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, sound: true, badge: true);
  }

  void initializePlatformSpecifics() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('notification');
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {});
  }

  Future<void> scheduleNotification() async {
    var dateTime = tz.TZDateTime.now(tz.UTC).add(Duration(seconds: 5));
    var androidChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_desc',
        importance: Importance.max,
        priority: Priority.high,
        timeoutAfter: 5000);
    var platformChannelSpecifics =
        NotificationDetails(android: androidChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1, 'title', 'body', dateTime, platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    return Future.value();
  }
}
