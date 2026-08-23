import 'package:firebase_messaging/firebase_messaging.dart';

class HomiGoFirebaseMessage {
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const HomiGoFirebaseMessage({
    this.messageId,
    this.title,
    this.body,
    this.data = const {},
  });

  factory HomiGoFirebaseMessage.fromRemoteMessage(RemoteMessage message) {
    return HomiGoFirebaseMessage(
      messageId: message.messageId,
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
    );
  }
}

class HomiGoFirebaseMessaging {
  final FirebaseMessaging _messaging;

  HomiGoFirebaseMessaging({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool badge = true,
    bool sound = true,
    bool announcement = false,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
  }) {
    return _messaging.requestPermission(
      alert: alert,
      badge: badge,
      sound: sound,
      announcement: announcement,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
    );
  }

  Future<String?> getToken() {
    return _messaging.getToken();
  }

  Future<void> deleteToken() {
    return _messaging.deleteToken();
  }

  Stream<String> get onTokenRefresh {
    return _messaging.onTokenRefresh;
  }

  Stream<HomiGoFirebaseMessage> get foregroundMessages {
    return FirebaseMessaging.onMessage.map(
      HomiGoFirebaseMessage.fromRemoteMessage,
    );
  }

  Stream<HomiGoFirebaseMessage> get openedMessages {
    return FirebaseMessaging.onMessageOpenedApp.map(
      HomiGoFirebaseMessage.fromRemoteMessage,
    );
  }

  Future<HomiGoFirebaseMessage?> getInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message == null) {
      return null;
    }

    return HomiGoFirebaseMessage.fromRemoteMessage(message);
  }

  Future<void> subscribeToTopic(String topic) {
    return _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) {
    return _messaging.unsubscribeFromTopic(topic);
  }
}
