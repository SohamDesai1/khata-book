import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hisaab/screens/display.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Shared extends StatefulWidget {
  const Shared({super.key});

  @override
  State<Shared> createState() => _SharedState();
}

class _SharedState extends State<Shared> {
  Map<String, List<Map<String, dynamic>>> groupedExpenses = {};

  @override
  void initState() {
    super.initState();
    _fetchAllExpenses();
  }

  // Fetch all expenses from the database
  Future<void> _fetchAllExpenses() async {
    try {
      final response = await Supabase.instance.client
          .from('expenses')
          .select()
          .order('date', ascending: false);
      if (response.isEmpty) {
        log('Error fetching data');
      } else {
        for (var expense in response) {
          final date = DateTime.parse(expense['date'])
              .toLocal()
              .toIso8601String()
              .split('T')[0];
          if (groupedExpenses.containsKey(date)) {
            groupedExpenses[date]!.add(expense);
          } else {
            groupedExpenses[date] = [expense];
          }
        }
        setState(() {});
      }
    } catch (e) {
      log('Exception fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: ListView.builder(
        itemCount: groupedExpenses.keys.length,
        itemBuilder: (context, index) {
          final date = groupedExpenses.keys.elementAt(index);
          final expenses = groupedExpenses[date];
          // log(groupedExpenses.toString());
          return ListTile(
            title: Text(
                'Expenses on ${DateFormat('d MMMM').format(DateTime.parse(date))}'),
            onTap: () {
              // Navigate to the detail page with the selected expense data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Display(expenses: expenses!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
