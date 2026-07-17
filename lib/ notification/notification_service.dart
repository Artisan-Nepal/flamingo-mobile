import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/notification/notification_router.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/firebase_options.dart';
import 'package:flamingo/shared/constant/common_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Runs in a separate background isolate with no access to the app's widget
// tree/GetIt locator/Navigator - registered only because FCM expects a
// background handler to exist for background delivery to behave correctly.
// Every push this app sends carries a `notification` block (see the API's
// message templates), so the OS already displays it without any code here;
// actual tap-routing happens once the user opens the app, in
// onMessageOpenedApp/getInitialMessage below, which run in the normal
// foreground isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') rethrow;
    }
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<String?> getNotificationToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  // main() awaits this before runApp(), so NOTHING here may throw or hang -
  // a rejection propagates up and prevents runApp() entirely (white screen).
  // The FCM network/platform calls (requestPermission, subscribeToTopic)
  // throw on an iOS simulator, which has no APNs token, so they're isolated
  // into a fire-and-forget helper below rather than awaited in this path.
  setup() async {
    try {
      const androidChannel = AndroidNotificationChannel(
        CommonConstants.notificationChannel,
        '${CommonConstants.notificationChannel} channel',
        importance: Importance.max,
      );

      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings(),
      );

      // local notification
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          _routeFromPayload(response.payload);
        },
      );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      // when app is terminated and opened by tapping the notification tray
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message == null) return;
        // setup() runs before runApp() (see main.dart), so the navigator
        // isn't mounted yet - defer routing until the first frame exists.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NotificationRouter.route(message.data);
        });
      }).catchError((_) {});

      // when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _display(message);
      });

      // when app is backgrounded and the user taps the notification tray
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        NotificationRouter.route(message.data);
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        locator<UserRepository>().updateDeviceNotificationToken(token);
      });
    } catch (_) {}

    // Fire-and-forget: these hit the platform push service and throw on an
    // iOS simulator (no APNs token). Not awaited so they can never block or
    // crash startup.
    _requestPermissionAndSubscribe();
  }

  Future<void> _requestPermissionAndSubscribe() async {
    // Android 13+ blocks notifications unless the app asks at runtime; iOS
    // has always required this. A denial just means silent pushes (still
    // visible in the in-app inbox).
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {}

    // Every install, logged in or not - promo broadcasts (see
    // PromoBannerService.notify on the API) target this topic rather than a
    // per-user token list.
    try {
      await FirebaseMessaging.instance
          .subscribeToTopic(CommonConstants.promotionsTopic);
    } catch (_) {}
  }

  void _routeFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload));
      NotificationRouter.route(data);
    } catch (_) {}
  }

  void _display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          CommonConstants.notificationChannel,
          '${CommonConstants.notificationChannel} channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      );
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        // Carried through to onDidReceiveNotificationResponse so a tap on
        // this foreground-displayed notification routes the same way a
        // background/terminated tap does.
        payload: jsonEncode(message.data),
      );
    } on Exception catch (_) {}
  }
}
