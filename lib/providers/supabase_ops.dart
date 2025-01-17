// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hisaab/providers/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';

final supabaseProvider = Provider<SupabaseOps>((ref) {
  return SupabaseOps(ref);
});

class SupabaseOps {
  final ProviderRef ref;
  VoidCallback? onStateChange;

  SupabaseOps(this.ref);
  final supabase = Supabase.instance.client;

  Future<Map<String, List<Map<String, dynamic>>>> fetchAllExpenses() async {
    try {
      final response = await supabase
          .from('expenses')
          .select()
          .order('date', ascending: false);

      if (response.isEmpty) {
        log('Error fetching data');
        return {};
      } else {
        Map<String, List<Map<String, dynamic>>> groupedExpenses = {};
        for (var expense in response) {
          final date =
              DateTime.parse(expense['date']).toIso8601String().split('T')[0];
          if (groupedExpenses.containsKey(date)) {
            groupedExpenses[date]!.add(expense);
          } else {
            groupedExpenses[date] = [expense];
          }
        }
        return groupedExpenses;
      }
    } catch (e) {
      log('Exception fetching data: $e');
      return {};
    }
  }

  Future<void> saveToSupabase(
    BuildContext context,
    Map<TextEditingController, Map<String, dynamic>> samaan,
    TextEditingController countController,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    bool hasSaved = false; // Track if any expense is saved
    countController.clear(); // Clear the count controller

    try {
      // Get the current date
      final DateTime currentDate = DateTime.now();

      // Iterate through the items in the samaan map and save each one
      for (var entry in samaan.entries) {
        final String name = entry.value['name'] ?? '';
        final String amount = entry.value['amount'] ?? '0';

        // Ensure that name and amount are not empty before saving
        if (name.isNotEmpty && amount.isNotEmpty) {
          final response =
              await Supabase.instance.client.from('expenses').insert({
            'date': currentDate.toIso8601String(), // Save current date
            'name': name,
            'username': ref.read(selectedUserProvider),
            'amount': int.tryParse(amount) ?? 0, // Convert amount to int
          }).select();

          if (response.isEmpty) {
            // Handle error if needed
            log('Error saving to Supabase for item: $name');
          } else {
            hasSaved = true; // Mark as saved
            log('Saved: $name, $amount');
          }
        }
      }

      // Clear the samaan map and text fields after saving
      if (hasSaved) {
        if (onStateChange != null) {
          onStateChange!();
        }
        // Show the dialog to indicate successful save
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Saved!"),
              content: const Text("Expenses saved successfully"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any exceptions
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Expenses not saved"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      log('Exception saving to Supabase: $e');
    }
  }

  Future<void> deleteExpense(BuildContext context, int id) async {
    try {
      await Supabase.instance.client.from('expenses').delete().eq('id', id);
    } catch (e) {
      log('Exception deleting expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting expense: $e')),
      );
    }
  }

  Future<List<String>> fetchAllExpensesDates() async {
    try {
      final response = await supabase
          .from('expenses')
          .select('date')
          .order('date', ascending: false);
      if (response.isEmpty) {
        log('Error fetching data');
        return [];
      } else {
        final dates =
            response.map((expense) => expense['date'] as String).toList();
        return dates;
      }
    } catch (e) {
      log('Exception fetching data: $e');
      return [];
    }
  }
}
