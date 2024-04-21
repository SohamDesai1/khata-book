import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier(0);
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier(super.state);

  void setIndex(int index) {
    state = index;
  }
}
