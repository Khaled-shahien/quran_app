import 'package:flutter/foundation.dart';

/// Performance-optimized mixin for granular state notifications
///
/// This mixin provides selective notifyListeners functionality to
/// avoid unnecessary rebuilds of entire widget trees.
mixin SelectiveNotifyMixin on ChangeNotifier {
  final Set<String> _changedFields = {};

  /// Notify listeners only for specific fields
  void notifyForFields(Set<String> fields) {
    _changedFields.addAll(fields);
    notifyListeners();
  }

  /// Notify listeners for a single field
  void notifyForField(String field) {
    _changedFields.add(field);
    notifyListeners();
  }

  /// Clear the changed fields tracking
  void clearChangedFields() {
    _changedFields.clear();
  }

  /// Check if a specific field has changed
  bool hasFieldChanged(String field) {
    return _changedFields.contains(field);
  }

  /// Get all changed fields since last clear
  Set<String> get changedFields => _changedFields;
}

/// Performance-optimized ValueNotifier for primitive types
///
/// Uses == operator for equality checking to avoid unnecessary rebuilds
class PerformanceValueNotifier<T> extends ValueNotifier<T> {
  PerformanceValueNotifier(super.value);

  @override
  set value(T newValue) {
    // Only notify if the value actually changed
    if (value != newValue) {
      super.value = newValue;
    }
  }
}
