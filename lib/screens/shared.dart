import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/routes/routers.dart';
import 'package:hisaab/screens/display.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Shared extends ConsumerStatefulWidget {
  const Shared({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedState();
}

class _SharedState extends ConsumerState<Shared> {
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
        body: groupedExpenses.isNotEmpty
            ? Center(
                child: SizedBox(
                  width: 60.w,
                  height: 90.h,
                  child: ListView.builder(
                    itemCount: groupedExpenses.keys.length,
                    itemBuilder: (context, index) {
                      final date = groupedExpenses.keys.elementAt(index);
                      final expenses = groupedExpenses[date];
                      // log(groupedExpenses.toString());
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to the detail page with the selected expense data
                              ref
                                  .read(goRouterProvider)
                                  .pushNamed("Display", extra: expenses);
                            },
                            child: Container(
                              // width: 10.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 118, 187, 255),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  'Expenses on ${DateFormat('d MMMM').format(DateTime.parse(date))}',
                                  style: TextStyle(fontSize: 4.5.w),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
            : Center(
                child: Text(
                  "NO EXPENSES",
                  style: TextStyle(fontSize: 4.5.w),
                ),
              ));
  }
}
