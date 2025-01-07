import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedUserProvider =
    StateNotifierProvider<SelectedUserNotifier, String?>((ref) {
  return SelectedUserNotifier();
});

class SelectedUserNotifier extends StateNotifier<String?> {
  SelectedUserNotifier() : super(null);

  void setUser(String user) {
    state = user;
    _saveUserToStorage(user);
  }

  Future<void> _saveUserToStorage(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedUser', user);
  }

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('selectedUser');
  }
}


final showUserSelectionPromptProvider =
    StateNotifierProvider<ShowPromptNotifier, bool>((ref) {
  return ShowPromptNotifier();
});

class ShowPromptNotifier extends StateNotifier<bool> {
  ShowPromptNotifier() : super(false) {
    _loadPromptStatus();
  }

  Future<void> _loadPromptStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownPrompt = prefs.getBool('hasShownPrompt') ?? true;

    if (!hasShownPrompt) {
      await SelectedUserNotifier().loadUserFromStorage();
    }

    state = hasShownPrompt;
  }

  Future<void> markPromptAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownPrompt', false);
    state = false;
  }
}
