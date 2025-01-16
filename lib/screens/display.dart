import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/routers.dart';
import '../providers/bottom_nav.dart';
import '../providers/supabase_ops.dart';
// import 'package:hisaab/screens/shared.dart';
// import 'package:hisaab/widgets/bottom_navbar.dart';

class Display extends ConsumerWidget {
  final List<Map<String, dynamic>> expenses;
  final String date;
  const Display({super.key, required this.expenses, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScrollController scrollController = ScrollController();
    // Calculate the total expense
    final totalExpense = expenses.fold<int>(
      0,
      (sum, expense) => sum + ((expense['amount'] ?? 0) as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: expenses.isNotEmpty
          ? Column(
              children: [
                // Display the total expense
                SizedBox(
                  height: 80.h,
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return ListTile(
                          title: Text(
                            expense['name'] ?? 'Unnamed Item',
                            style: TextStyle(fontSize: 2.h),
                          ),
                          subtitle: Text(
                            'Amount: ${expense['amount'] ?? 0}',
                            style: TextStyle(fontSize: 2.h),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Confirm deletion before deleting the expense
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Expense'),
                                  content: const Text(
                                      'Are you sure you want to delete this expense?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref
                                            .read(navigationProvider.notifier)
                                            .setIndex(1);
                                        ref.read(supabaseProvider).deleteExpense(
                                            context,
                                            expense[
                                                'id']); // Call delete function
                                        ref
                                            .read(goRouterProvider)
                                            .goNamed("Shared");
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  'Total Expense: $totalExpense',
                  style: TextStyle(fontSize: 3.h, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1.h,
                ),
                expenses.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          ref.read(goRouterProvider).pushNamed('Edit',
                              queryParameters: {'date': date});
                        },
                        child: const Text('Edit'))
                    : const SizedBox.shrink()
              ],
            )
          : Center(
              child: Text(
                "No Expenses for this day!",
                style: TextStyle(fontSize: 3.h),
              ),
            ),
    );
  }
}
