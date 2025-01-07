import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/providers/notification.dart';
import 'package:sizer/sizer.dart';
import 'routes/routers.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hisaab/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'models/expense.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);
  // Hive.initFlutter('hive_db');
  // Hive.registerAdapter(ExpenseAdapter());

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_PROJECT_URL']!,
      anonKey: dotenv.env['SUPABASE_API_KEY']!);
  runApp(const ProviderScope(child: MyApp()));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification clicked: ${response.payload}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Foreground message received: ${message.notification?.title}');

    var ref = ProviderContainer();
    NotificationRepo(ref as ProviderRef).showNotification(
      message.notification?.title ?? 'New Transaction',
      message.notification?.body ?? 'You have a new transaction',
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    var ref = ProviderContainer();
    ref.read(goRouterProvider).go('/shared');
  });
}

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return SafeArea(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              canvasColor: const Color.fromARGB(255, 255, 255, 255),
              appBarTheme: AppBarTheme(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  toolbarHeight: 80,
                  elevation: 0,
                  titleTextStyle: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  iconTheme: const IconThemeData(color: Colors.white)),
            ),
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            routerDelegate: router.routerDelegate,
          );
        },
      ),
    );
  }
}
