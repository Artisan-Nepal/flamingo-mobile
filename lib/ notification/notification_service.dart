import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/firebase_options.dart';
import 'package:flamingo/shared/constant/common_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  Future<String?> getNotificationToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  setup() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    // local notification
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );

    // when app is terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print(message);
      if (message != null) {}
    });

    // when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification!.toString());
      }

      _display(message);
    });

    // when app is in background and user click the notification tray
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      locator<UserRepository>().updateDeviceNotificationToken(token);
    });
  }

  void _display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          CommonConstants.notificationChannel,
          '${CommonConstants.notificationChannel} channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
