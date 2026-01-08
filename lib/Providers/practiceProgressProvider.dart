import 'package:wordstudy_app/generalimports.dart';

class PracticeProgressProvider extends ChangeNotifier {
  double vowelsProgress = 0.0;
  double oppositesProgress = 0.0;

  /// 🔹 Load saved progress (call on app start)
  Future<void> loadProgress() async {
    vowelsProgress = await SessionManager.getProgress(
      SessionManager.vowels(),
    );
    oppositesProgress = await SessionManager.getProgress(
      SessionManager.opposites(),
    );
    notifyListeners();
  }

  /// 🔹 Update vowels progress
  Future<void> updateVowelsProgress(double value) async {
    vowelsProgress = value.clamp(0.0, 1.0);
    await SessionManager.setProgress(
      SessionManager.vowels(),
      vowelsProgress,
    );
    notifyListeners();
  }

  /// 🔹 Update opposites progress
  Future<void> updateOppositesProgress(double value) async {
    oppositesProgress = value.clamp(0.0, 1.0);
    await SessionManager.setProgress(
      SessionManager.opposites(),
      oppositesProgress,
    );
    notifyListeners();
  }
}
