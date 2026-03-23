import 'package:flutter/material.dart';
import '../../domain/models/khatma_model.dart';
import '../../data/repositories/khatma_repository.dart';

class KhatmaProvider extends ChangeNotifier {
  final KhatmaRepository repository;
  KhatmaModel? _activeKhatma;

  KhatmaProvider({required this.repository}) {
    _loadActiveKhatma();
  }

  KhatmaModel? get activeKhatma => _activeKhatma;
  bool get hasActiveKhatma => _activeKhatma != null;

  void _loadActiveKhatma() {
    _activeKhatma = repository.getActiveKhatma();
    notifyListeners();
  }

  Future<void> startNewKhatma(KhatmaModel khatma) async {
    await repository.saveKhatma(khatma);
    _activeKhatma = khatma;
    notifyListeners();
  }

  Future<void> updateProgress({
    required int currentJuz,
    required int completedDays,
  }) async {
    if (_activeKhatma != null) {
      final updatedKhatma = _activeKhatma!.copyWith(
        currentJuz: currentJuz,
        completedDays: completedDays,
      );
      await repository.saveKhatma(updatedKhatma);
      _activeKhatma = updatedKhatma;
      notifyListeners();
    }
  }

  Future<void> markCurrentWirdAsFinished() async {
    if (_activeKhatma != null) {
      double juzIncrement = 1.0;
      if (_activeKhatma!.amountType == 'جزء') {
        final valStr = _activeKhatma!.amountValue.split(' ').first;
        final val = int.tryParse(valStr);
        if (val != null) {
          juzIncrement = val.toDouble();
        } else if (_activeKhatma!.amountValue == 'جزء') {
          juzIncrement = 1.0;
        } else if (_activeKhatma!.amountValue == 'جزءان') {
          juzIncrement = 2.0;
        }
      } else if (_activeKhatma!.amountType == 'ربع') {
        final valStr = _activeKhatma!.amountValue.split(' ').first;
        final val = int.tryParse(valStr);
        if (val != null) {
          juzIncrement = val / 8.0; // 8 quarters in a Juz
        } else if (_activeKhatma!.amountValue == 'ربع') {
          juzIncrement = 1 / 8.0;
        } else if (_activeKhatma!.amountValue == 'ربعان') {
          juzIncrement = 2 / 8.0;
        }
      }

      int nextJuz = _activeKhatma!.currentJuz + juzIncrement.ceil();
      if (nextJuz > 30) nextJuz = 30; // Cap at 30

      int nextCompletedDays = _activeKhatma!.completedDays + 1;

      if (nextCompletedDays >= _activeKhatma!.durationDays || nextJuz > 30) {
        // Khatma completed
        await completeKhatma();
      } else {
        await updateProgress(
          currentJuz: nextJuz,
          completedDays: nextCompletedDays,
        );
      }
    }
  }

  Future<void> completeKhatma() async {
    if (_activeKhatma != null) {
      final updatedKhatma = _activeKhatma!.copyWith(isCompleted: true);
      await repository.saveKhatma(updatedKhatma);
      _activeKhatma = updatedKhatma;
      notifyListeners();
    }
  }

  Future<void> cancelKhatma() async {
    await repository.deleteActiveKhatma();
    _activeKhatma = null;
    notifyListeners();
  }
}
