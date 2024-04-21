import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/home.dart';
import '../screens/shared.dart';

final GlobalKey<NavigatorState> _root = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shell = GlobalKey(debugLabel: 'shell');


final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _root,
    initialLocation: '/',
    routes: [
        ShellRoute(
        navigatorKey: _shell,
        builder: (context, state, child) => BottomNavBar(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: "Home",
            parentNavigatorKey: _shell,
            builder: (context, state) => Home(
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/shared',
            name: "Shared",
            parentNavigatorKey: _shell,
            builder: (context, state) => Shared(key: state.pageKey),
          ),
        ],
      ),
    ],
  );
});
