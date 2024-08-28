import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  const Display({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return ListTile(
            title: Text(expense['name'] ?? 'Unnamed Item'),
            subtitle: Text('Amount: ${expense['amount'] ?? 0}'),
          );
        },
      ),
    );
  }
}
