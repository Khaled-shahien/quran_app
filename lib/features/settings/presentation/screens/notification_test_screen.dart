import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/notification_provider.dart';

/// Diagnostic screen for verifying notification permissions and scheduling.
class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialNotificationState();
    });
  }

  Future<void> _loadInitialNotificationState() async {
    final provider = context.read<NotificationProvider>();
    await provider.initialize();
    await provider.getPendingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختبار الإشعارات')),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionCard(
                  title: 'حالة الصلاحيات',
                  icon: Icons.verified_user_outlined,
                  children: [
                    _InfoRow(
                      label: 'الحالة',
                      value: provider.permissionStatus ?? 'غير معروفة',
                    ),
                    _InfoRow(
                      label: 'جاهزية الخدمة',
                      value: provider.isInitialized ? 'جاهزة' : 'قيد التشغيل',
                    ),
                  ],
                ),
                _SectionCard(
                  title: 'الإشعارات المحلية',
                  icon: Icons.notifications_active_outlined,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _showImmediateNotification(provider),
                          icon: const Icon(Icons.flash_on),
                          label: const Text('إشعار فوري'),
                        ),
                        FilledButton.icon(
                          onPressed: () =>
                              _scheduleDelayedNotification(provider),
                          icon: const Icon(Icons.schedule),
                          label: const Text('إشعار بعد دقيقة'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _cancelAllNotifications(provider),
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text('إلغاء الكل'),
                        ),
                      ],
                    ),
                  ],
                ),
                _SectionCard(
                  title: 'إشعارات الدفع (FCM)',
                  icon: Icons.cloud_queue,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _requestPermissions(provider),
                          icon: const Icon(Icons.lock_open_outlined),
                          label: const Text('طلب الصلاحيات'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoRow(
                            label: 'رمز FCM:',
                            value: _maskedToken(provider.fcmToken),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _refreshFcmToken(provider),
                          icon: const Icon(Icons.refresh),
                          label: const Text('تحديث'),
                        ),
                        TextButton.icon(
                          onPressed: provider.fcmToken == null
                              ? null
                              : () => _copyFcmToken(provider),
                          icon: const Icon(Icons.copy),
                          label: const Text('نسخ'),
                        ),
                      ],
                    ),
                  ],
                ),
                _SectionCard(
                  title: 'الإشعارات المجدولة',
                  icon: Icons.pending_actions_outlined,
                  trailing: TextButton.icon(
                    onPressed: () => provider.getPendingNotifications(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('تحديث'),
                  ),
                  children: [
                    if (provider.pendingNotifications.isEmpty)
                      Text(
                        'لا توجد إشعارات مجدولة',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      ...provider.pendingNotifications.map(
                        (notification) => _PendingNotificationTile(
                          notification: notification,
                          onCancel: () => _cancelNotification(
                            provider,
                            notification['id'] as int,
                          ),
                        ),
                      ),
                  ],
                ),
                _SectionCard(
                  title: 'التحكم في المنبهات',
                  icon: Icons.alarm_on_outlined,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _rescheduleAlarms(provider),
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('إعادة جدولة جميع المنبهات'),
                    ),
                  ],
                ),
                _SectionCard(
                  title: 'سجلات التصحيح',
                  icon: Icons.bug_report_outlined,
                  trailing: TextButton.icon(
                    onPressed: provider.clearLogs,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('مسح'),
                  ),
                  children: [
                    if (provider.debugLogs.isEmpty)
                      Text(
                        'لا توجد سجلات',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      ...provider.debugLogs.map(
                        (log) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            log,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showImmediateNotification(NotificationProvider provider) async {
    try {
      await provider.scheduleTestNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'اختبار فوري',
        body: 'هذا إشعار اختبار فوري ناجح',
      );
      if (!mounted) return;
      _showSnackBar('تم إظهار الإشعار بنجاح');
    } catch (error) {
      if (!mounted) return;
      _showSnackBar('فشل الاختبار: $error');
    }
  }

  Future<void> _scheduleDelayedNotification(
    NotificationProvider provider,
  ) async {
    try {
      await provider.scheduleDelayedNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'إشعار بعد دقيقة',
        body: 'سيظهر هذا الإشعار بعد دقيقة من الآن',
      );
      await provider.getPendingNotifications();
      if (!mounted) return;
      _showSnackBar('تمت جدولة الإشعار بعد دقيقة');
    } catch (error) {
      if (!mounted) return;
      _showSnackBar('فشل الجدولة: $error');
    }
  }

  Future<void> _cancelAllNotifications(NotificationProvider provider) async {
    await provider.cancelAllNotifications();
    await provider.getPendingNotifications();
    if (!mounted) return;
    _showSnackBar('تم إلغاء جميع الإشعارات');
  }

  Future<void> _requestPermissions(NotificationProvider provider) async {
    await provider.requestPermissions();
    if (!mounted) return;
    _showSnackBar('تم طلب الصلاحيات');
  }

  Future<void> _refreshFcmToken(NotificationProvider provider) async {
    await provider.refreshFCMToken();
    if (!mounted) return;
    _showSnackBar('تم تحديث الرمز');
  }

  Future<void> _copyFcmToken(NotificationProvider provider) async {
    final token = provider.fcmToken;
    if (token == null || token.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: token));
    await provider.copyFCMToken();
    if (!mounted) return;
    _showSnackBar('تم نسخ الرمز');
  }

  Future<void> _cancelNotification(
    NotificationProvider provider,
    int id,
  ) async {
    await provider.cancelNotification(id);
    await provider.getPendingNotifications();
  }

  Future<void> _rescheduleAlarms(NotificationProvider provider) async {
    await provider.rescheduleAllAlarms();
    if (!mounted) return;
    _showSnackBar('تم إعادة جدولة جميع المنبهات');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _maskedToken(String? token) {
    if (token == null || token.isEmpty) return 'غير متاح';
    if (token.length <= 8) return '********';
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _PendingNotificationTile extends StatelessWidget {
  const _PendingNotificationTile({
    required this.notification,
    required this.onCancel,
  });

  final Map<String, dynamic> notification;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(notification['title']?.toString() ?? ''),
      subtitle: Text(notification['body']?.toString() ?? ''),
      trailing: IconButton(
        tooltip: 'إلغاء',
        icon: const Icon(Icons.cancel),
        onPressed: onCancel,
      ),
    );
  }
}
