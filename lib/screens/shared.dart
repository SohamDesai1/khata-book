import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/routes/routers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class Shared extends ConsumerStatefulWidget {
  const Shared({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedState();
}

class _SharedState extends ConsumerState<Shared> {
  Map<String, List<Map<String, dynamic>>> groupedExpenses = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Future<Map<String, List<Map<String, dynamic>>>> fetchAllExpenses() async {
    try {
      final response = await Supabase.instance.client
          .from('expenses')
          .select()
          .order('date', ascending: false);

      if (response.isEmpty) {
        log('Error fetching data');
        return {}; // Return an empty map in case of error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2023, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) async {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          final selectedDate = selectedDay.toIso8601String().split('T')[0];
          var expense = await fetchAllExpenses();
          final expenses = expense[selectedDate] ?? [];
          ref.read(goRouterProvider).pushNamed("Display",
              extra: expenses, queryParameters: {'date': selectedDay.toIso8601String()});
        },
        shouldFillViewport: true,
        calendarFormat: CalendarFormat.month,
        onFormatChanged: (format) => CalendarFormat.week,
      ),
    );
  }
}
