import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _countController = TextEditingController();
  final Map<TextEditingController, Map<String, dynamic>> samaan = {};
  bool toshowb = false;

  @override
  void dispose() {
    // Dispose of the count controller
    _countController.dispose();

    // Dispose of all player controllers
    for (var kinnariData in samaan.keys) {
      kinnariData.dispose();
    }
    super.dispose();
  }

  void _generateTextFields(int count) {
    // Clear existing controllers
    for (var kinnariData in samaan.keys) {
      kinnariData.dispose();
    }
    samaan.clear();

    // Generate new controllers
    for (int i = 0; i < count; i++) {
      final samaanNameController = TextEditingController();
      // final playerAmountController = TextEditingController();
      samaan[samaanNameController] = {
        'name': '',
        'amount': '',
      };
    }
    setState(() {});
  }

  Future<void> saveToSupabase() async {
    FocusManager.instance.primaryFocus?.unfocus();
    bool hasSaved = false; // Track if any expense is saved

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

      // Show the dialog once if any expense was saved successfully
      if (hasSaved) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Saved!"),
              content: const Text("Expenses saved successfully"),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"))
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
                  child: const Text("OK"))
            ],
          );
        },
      );
      log('Exception saving to Supabase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Your Expenses'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 30.w,
              child: TextField(
                controller: _countController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Ketlo Samaan?',
                    labelStyle: TextStyle(fontSize: 4.w)),
                onChanged: (value) {
                  final count = int.tryParse(value) ?? 0;
                  _generateTextFields(count);
                  setState(() {
                    toshowb = true;
                  });
                },
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                itemCount: samaan.length,
                itemBuilder: (context, index) {
                  final samaanNameController = samaan.keys.elementAt(index);
                  final kinnariData = samaan[samaanNameController]!;
                  final playerAmountController = TextEditingController();
                  playerAmountController.text = kinnariData['amount'] ?? '';

                  return Center(
                    child: SizedBox(
                      width: 95.w,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 30.w,
                              child: TextField(
                                controller: samaanNameController,
                                decoration: InputDecoration(
                                    labelText: 'Samaan ${index + 1}'),
                                onChanged: (value) {
                                  samaan[samaanNameController]!['name'] = value;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 10.w,
                              child: TextField(
                                controller: playerAmountController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: 'Amount'),
                                onChanged: (value) {
                                  samaan[samaanNameController]!['amount'] =
                                      value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            toshowb
                ? ElevatedButton(
                    onPressed: () => saveToSupabase(),
                    child: const Text("Save"))
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
