import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:hisaab/screens/add_transaction.dart';
import 'package:hisaab/screens/display.dart';
import 'package:hisaab/screens/edit.dart';
import 'package:hisaab/screens/select_user.dart';
import 'package:hisaab/screens/mummy_expenses.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/home.dart';
import '../screens/shared.dart';
import '../providers/user.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final showPrompt = ref.watch(showUserSelectionPromptProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (showPrompt) {
        return '/select_user';
      }
      return null;
    },
    routes: [
      // GoRoute(
      //   path: '/add_transaction',
      //   name: "Add Transaction",
      //   builder: (context, state) => Transaction(
      //     key: state.pageKey,
      //   ),
      // ),
      GoRoute(
          path: '/select_user',
          name: "Select User",
          builder: (context, state) {
            return const UserSelection();
          }),
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
          GoRoute(
              path: '/mummy',
              name: 'Mummy',
              builder: (context, state) => const ExpensesMummy()),
        ],
      ),
      GoRoute(
        path: '/display',
        name: 'Display',
        builder: (context, state) {
          final expenses = state.extra as List<Map<String, dynamic>>?;
          final date = state.uri.queryParameters['date']!;
          return Display(expenses: expenses ?? [], date: date);
        },
      ),
      GoRoute(
        path: '/edit',
        name: 'Edit',
        builder: (context, state) {
          final date = state.uri.queryParameters['date']!;
          return Edit(date: date);
        },
      ),
    ],
  );
});
