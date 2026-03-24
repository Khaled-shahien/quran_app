import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';
import '../navigation/notification_router.dart';
import 'notification_service.dart';

/// Background message handler - MUST be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
    '[FCM][BG] messageId=${message.messageId} data=${message.data} hasNotification=${message.notification != null}',
  );

  // Ensure Firebase is initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Show notification even when app is in background
  final NotificationService notificationService = NotificationService();
  await notificationService.initialize(requestPermissions: false);
  await notificationService.showNotification(
    id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title: message.notification?.title ?? 'Notification',
    body: message.notification?.body ?? '',
    payload: message.data['type'] ?? 'general',
    payloadData: Map<String, dynamic>.from(message.data),
  );
}

/// Firebase Cloud Messaging Service
///
/// Handles:
/// - FCM initialization
/// - Permission requests
/// - Foreground messages (onMessage)
/// - Background messages (onBackgroundMessage)
/// - Notification taps (onMessageOpenedApp)
/// - Token management
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;
  bool _isInitialized = false;
  static const int _maxInitAttempts = 3;

  // Callbacks for notification interactions
  Function(String type, Map<String, dynamic> data)? onNotificationTap;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    if (_isInitialized) return;

    for (int attempt = 1; attempt <= _maxInitAttempts; attempt++) {
      try {
        debugPrint('[FCM] Initialization attempt $attempt started');

        // Initialize Firebase if not already done
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        }

        // Set up background message handler
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );
        debugPrint('[FCM] Background message handler registered');

        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        // Request permissions
        await _requestPermissions();

        // Set up message handlers
        await _setupMessageHandlers();

        // Get and log FCM token with timeout to avoid startup stalls.
        final token = await _firebaseMessaging.getToken().timeout(
          const Duration(seconds: 6),
        );
        debugPrint('[FCM] Token generated: $token');

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          debugPrint('[FCM] Token refreshed: $newToken');
          _updateTokenInBackend(newToken);
        });

        _isInitialized = true;
        debugPrint('[FCM] Firebase Messaging Service initialized successfully');
        return;
      } catch (e) {
        debugPrint(
          '[FCM] Initialization failed (attempt $attempt/$_maxInitAttempts): $e',
        );

        if (attempt == _maxInitAttempts) {
          rethrow;
        }

        await Future<void>.delayed(Duration(seconds: attempt * 2));
      }
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // iOS/macOS permissions
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        // Check current authorization status
        NotificationSettings settings = await _firebaseMessaging
            .requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              provisional: false,
              sound: true,
            );

        debugPrint(
          'iOS Notification Settings granted: ${settings.authorizationStatus}',
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('User granted notification permission');
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
          debugPrint('User granted provisional notification permission');
        } else {
          debugPrint('User declined notification permission');
        }
      }

      // Android permissions are handled by flutter_local_notifications
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }

  /// Set up message handlers
  Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        '[FCM][FG] messageId=${message.messageId} title=${message.notification?.title} body=${message.notification?.body} data=${message.data}',
      );
      _handleForegroundMessage(message);
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        '[FCM][OPENED_APP] messageId=${message.messageId} data=${message.data}',
      );
      _handleNotificationTap(message);
    });

    // Check if app was opened from a notification
    final RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        '[FCM][INITIAL] App opened from terminated state: ${initialMessage.messageId}',
      );
      _handleNotificationTap(initialMessage);
    } else {
      debugPrint('[FCM][INITIAL] No initial notification payload');
    }
  }

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification for foreground message
    final NotificationService notificationService = NotificationService();
    notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data['type'] ?? 'general',
      payloadData: Map<String, dynamic>.from(message.data),
    );
    debugPrint('[FCM][FG] Local notification trigger requested');
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    final String type = message.data['type'] ?? 'general';
    final Map<String, dynamic> data = Map<String, dynamic>.from(message.data);

    debugPrint('[FCM][NAV] Routing notification type=$type data=$data');

    NotificationRouter.handleNotification(type: type, data: data);

    // Call callback if provided
    if (onNotificationTap != null) {
      onNotificationTap!(type, data);
    }
  }

  /// Update token in backend (placeholder)
  void _updateTokenInBackend(String token) {
    // Intentionally left as a hook for optional backend token registration.
    debugPrint('Token to be sent to backend: $token');
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Refresh FCM token
  Future<void> refreshToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      final newToken = await _firebaseMessaging.getToken();
      debugPrint('Token refreshed: $newToken');
      _updateTokenInBackend(newToken!);
    } catch (e) {
      debugPrint('Error refreshing token: $e');
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// Delete token (for logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      debugPrint('Token deleted');
    } catch (e) {
      debugPrint('Error deleting token: $e');
    }
  }
}
