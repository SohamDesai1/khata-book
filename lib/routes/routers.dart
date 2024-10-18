import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:hisaab/screens/add_transaction.dart';
import 'package:hisaab/screens/display.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/home.dart';
import '../screens/shared.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // GoRoute(
      //   path: '/add_transaction',
      //   name: "Add Transaction",
      //   builder: (context, state) => Transaction(
      //     key: state.pageKey,
      //   ),
      // ),
      ShellRoute(
        builder: (context, state, child) => BottomNavBar(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: "Home",
            builder: (context, state) => Home(
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/shared',
            name: "Shared",
            builder: (context, state) => Shared(key: state.pageKey),
          ),
        ],
      ),
      GoRoute(
        path: '/display',
        name: 'Display',
        builder: (context, state) {
          final expenses = state.extra as List<Map<String, dynamic>>?;
          return Display(expenses: expenses ?? []);
        },
      ),
    ],
  );
});
