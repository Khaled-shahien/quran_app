import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/settings_provider.dart';

/// Time Picker Dialog for setting alarm times
class AlarmTimePickerDialog extends StatefulWidget {
  final String alarmType;
  final String title;

  const AlarmTimePickerDialog({
    super.key,
    required this.alarmType,
    required this.title,
  });

  @override
  State<AlarmTimePickerDialog> createState() => _AlarmTimePickerDialogState();
}

class _AlarmTimePickerDialogState extends State<AlarmTimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _loadCurrentTime();
  }

  Future<void> _loadCurrentTime() async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final timeData = await settingsProvider.getAlarmTime(widget.alarmType);
    if (!mounted) return;

    setState(() {
      _selectedHour = timeData['hour'] ?? 0;
      _selectedMinute = timeData['minute'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Time picker
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hour picker
                _buildTimePickerColumn(
                  value: _selectedHour,
                  minValue: 0,
                  maxValue: 23,
                  label: 'الساعة',
                  onChanged: (value) {
                    setState(() {
                      _selectedHour = value;
                    });
                  },
                ),

                const SizedBox(width: 8),

                // Separator
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 8),

                // Minute picker
                _buildTimePickerColumn(
                  value: _selectedMinute,
                  minValue: 0,
                  maxValue: 59,
                  label: 'الدقيقة',
                  onChanged: (value) {
                    setState(() {
                      _selectedMinute = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Display formatted time
            Text(
              _formatTime(_selectedHour, _selectedMinute),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Save button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveTime(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      child: const Text('حفظ'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a column with time picker
  Widget _buildTimePickerColumn({
    required int value,
    required int minValue,
    required int maxValue,
    required String label,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Increment button
            IconButton(
              onPressed: value < maxValue
                  ? () {
                      onChanged(value + 1);
                    }
                  : null,
              icon: const Icon(Icons.arrow_upward),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
            const SizedBox(width: 8),
            // Decrement button
            IconButton(
              onPressed: value > minValue
                  ? () {
                      onChanged(value - 1);
                    }
                  : null,
              icon: const Icon(Icons.arrow_downward),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
      ],
    );
  }

  /// Format time for display
  String _formatTime(int hour, int minute) {
    final String minuteStr = minute.toString().padLeft(2, '0');
    final String period = hour >= 12 ? 'م' : 'ص';

    int displayHour = hour;
    if (displayHour > 12) {
      displayHour -= 12;
    } else if (displayHour == 0) {
      displayHour = 12;
    }

    return '${displayHour.toString().padLeft(2, '0')}:$minuteStr $period';
  }

  /// Save the selected time
  Future<void> _saveTime() async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    await settingsProvider.setAlarmTime(
      type: widget.alarmType,
      hour: _selectedHour,
      minute: _selectedMinute,
    );

    if (mounted) {
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ وقت ${widget.title}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
