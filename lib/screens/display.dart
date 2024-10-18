// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/routes/routers.dart';
// import 'package:hisaab/screens/shared.dart';
// import 'package:hisaab/widgets/bottom_navbar.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Display extends ConsumerWidget {
  final List<Map<String, dynamic>> expenses;

  const Display({super.key, required this.expenses});

  // Function to delete an expense from Supabase
  Future<void> _deleteExpense(BuildContext context, int id) async {
    try {
      await Supabase.instance.client.from('expenses').delete().eq('id', id);
    } catch (e) {
      log('Exception deleting expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting expense: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate the total expense
    final totalExpense = expenses.fold<int>(
      0,
      (sum, expense) => sum + ((expense['amount'] ?? 0) as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: Column(
        children: [
          // Display the total expense
          SizedBox(
            height: 60.h,
            child: ListView.builder(
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
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(goRouterProvider).goNamed("Shared");
                                _deleteExpense(context,
                                    expense['id']); // Call delete function
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
          Text(
            'Total Expense: $totalExpense',
            style: TextStyle(fontSize: 4.h, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
