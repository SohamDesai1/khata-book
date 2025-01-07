import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/providers/notification.dart';
import 'package:hisaab/routes/routers.dart';
import '../providers/user.dart';

class UserSelection extends ConsumerWidget {
  const UserSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select User"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Who is using the app?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ref.read(selectedUserProvider.notifier).setUser("Mummy");
                ref
                    .read(showUserSelectionPromptProvider.notifier)
                    .markPromptAsShown();
                ref.read(goRouterProvider).go('/');
                ref.read(notificationRepoProvider).updateFcmToken();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Text(
                "Mummy",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(selectedUserProvider.notifier).setUser("Papa");
                ref
                    .read(showUserSelectionPromptProvider.notifier)
                    .markPromptAsShown();
                ref.read(notificationRepoProvider).updateFcmToken();
                ref.read(goRouterProvider).go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Papa",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
