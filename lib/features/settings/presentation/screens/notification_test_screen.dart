import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/notification_provider.dart';

/// Notification Test Screen
///
/// Provides UI for testing all notification features:
/// - Permission management
/// - Local notifications
/// - FCM push notifications
/// - Pending notifications viewer
/// - Alarm controls
class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<NotificationProvider>();
      await provider.initialize();
      await provider.getPendingNotifications();
    } catch (e) {
      _showError('Initialization failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار الإشعارات'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (_isLoading && !provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Permission Status Card
                _buildPermissionCard(provider),

                const SizedBox(height: 16),

                // Local Notifications Section
                _buildLocalNotificationsSection(provider),

                const SizedBox(height: 16),

                // Push Notifications Section
                _buildPushNotificationsSection(provider),

                const SizedBox(height: 16),

                // Pending Notifications Section
                _buildPendingNotificationsSection(provider),

                const SizedBox(height: 16),

                // Alarm Controls Section
                _buildAlarmControlsSection(provider),

                const SizedBox(height: 16),

                // Debug Logs Section
                _buildDebugLogsSection(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionCard(NotificationProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getPermissionIcon(provider.permissionStatus),
                  color: _getPermissionColor(provider.permissionStatus),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'حالة الصلاحيات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        provider.permissionStatus ?? 'غير معروف',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getPermissionColor(provider.permissionStatus),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => provider.requestPermissions(),
                icon: const Icon(Icons.lock_open),
                label: const Text('طلب الصلاحيات'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalNotificationsSection(NotificationProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإشعارات المحلية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Immediate Test
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await provider.scheduleTestNotification(
                      id: DateTime.now().millisecondsSinceEpoch.remainder(
                        100000,
                      ),
                      title: 'اختبار فوري',
                      body: 'هذا إشعار اختبار فوري',
                    );
                    _showSuccess('تم إظهار الإشعار');
                  } catch (e) {
                    _showError('فشل الاختبار: $e');
                  }
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text('إشعار فوري'),
              ),
            ),

            const SizedBox(height: 8),

            // Delayed Test
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await provider.scheduleDelayedNotification(
                      id: DateTime.now().millisecondsSinceEpoch.remainder(
                        100000,
                      ),
                      title: 'اختبار مؤجل',
                      body:
                          'سيظهر هذا الإشعار '
                          'خلال دقيقة',
                    );
                    _showSuccess('تم جدولة الإشعار بعد دقيقة');
                  } catch (e) {
                    _showError('فشل الجدولة: $e');
                  }
                },
                icon: const Icon(Icons.schedule),
                label: const Text('إشعار بعد دقيقة'),
              ),
            ),

            const SizedBox(height: 8),

            // Cancel All
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await provider.cancelAllNotifications();
                    _showSuccess('تم إلغاء جميع الإشعارات');
                    await provider.getPendingNotifications();
                  } catch (e) {
                    _showError('فشل الإلغاء: $e');
                  }
                },
                icon: const Icon(Icons.cancel),
                label: const Text('إلغاء الكل'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPushNotificationsSection(NotificationProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إشعارات الدفع (FCM)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Token Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'رمز FCM:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.fcmToken ?? 'غير متوفر',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            if (provider.fcmToken != null) {
                              Clipboard.setData(
                                ClipboardData(text: provider.fcmToken!),
                              );
                              _showSuccess('تم نسخ الرمز');
                            }
                          },
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('نسخ'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => provider.refreshFCMToken(),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('تحديث'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Text(
                'لإرسال إشعار دفع:\n'
                '1. اذهب إلى Firebase Console\n'
                '2. Cloud Messaging → New notification\n'
                '3. استخدم الرمز أعلاه '
                'للإرسال لهذا الجهاز',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingNotificationsSection(NotificationProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإشعارات المجدولة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => provider.getPendingNotifications(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (provider.pendingNotifications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'لا توجد إشعارات مجدولة',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.pendingNotifications.length,
                itemBuilder: (context, index) {
                  final notification = provider.pendingNotifications[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.notifications),
                    ),
                    title: Text(notification['title'] ?? 'بدون عنوان'),
                    subtitle: Text(
                      'ID: ${notification['id']}\n'
                      '${notification['body'] ?? ''}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () async {
                        await provider.cancelNotification(notification['id']);
                        await provider.getPendingNotifications();
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmControlsSection(NotificationProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التحكم في المنبهات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await provider.rescheduleAllAlarms();
                    _showSuccess('تم إعادة جدولة جميع المنبهات');
                  } catch (e) {
                    _showError('فشل إعادة الجدولة: $e');
                  }
                },
                icon: const Icon(Icons.update),
                label: const Text('إعادة جدولة جميع المنبهات'),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'المنبهات النشطة:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _buildAlarmInfo('أذكار الصباح', '7:00 ص'),
            _buildAlarmInfo('أذكار المساء', '5:30 م'),
            _buildAlarmInfo('سورة الملك', '9:00 م'),
            _buildAlarmInfo('سورة البقرة', '8:30 م'),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmInfo(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(name)),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDebugLogsSection(NotificationProvider provider) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سجلات التصحيح',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => provider.clearLogs(),
                  icon: const Icon(Icons.clear_all),
                  label: const Text('مسح'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: provider.debugLogs.length,
                itemBuilder: (context, index) {
                  final log = provider.debugLogs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      log,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPermissionIcon(String? status) {
    switch (status) {
      case 'authorized':
        return Icons.check_circle;
      case 'denied':
        return Icons.cancel;
      case 'provisional':
        return Icons.info;
      default:
        return Icons.help_outline;
    }
  }

  Color _getPermissionColor(String? status) {
    switch (status) {
      case 'authorized':
        return Colors.green;
      case 'denied':
        return Colors.red;
      case 'provisional':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
