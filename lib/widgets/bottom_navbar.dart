import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/bottom_nav.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  final Widget child;
  const BottomNavBar({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  void _itemTapped(int index) {
    ref.read(navigationProvider.notifier).setIndex(index);
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/shared');

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedindex = ref.watch(navigationProvider);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        iconSize: 3.3.h,
        backgroundColor: const Color.fromARGB(255, 7, 65, 115),
        unselectedItemColor: const Color.fromARGB(255, 22, 121, 171),
        selectedItemColor: const Color.fromARGB(255, 93, 235, 215),
        onTap: (int val) => _itemTapped(val),
        currentIndex: selectedindex,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Shared",
            icon: Icon(Icons.list_alt_sharp),
          ),
        ],
      ),
    );
  }
}
