// progress_manager.dart
class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  final Set<String> _unlockedPhases = {'fase1'}; // Fase 1 sempre liberada inicialmente

  void unlockPhase(String phaseId) {
    _unlockedPhases.add(phaseId);
  }

  bool isPhaseUnlocked(String phaseId) {
    return _unlockedPhases.contains(phaseId);
  }

  // Para debug ou reset
  void resetProgress() {
    _unlockedPhases.clear();
    _unlockedPhases.add('fase1');
  }
}