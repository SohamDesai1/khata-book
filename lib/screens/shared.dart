import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/routers.dart';
import '../providers/supabase_ops.dart';
import 'package:table_calendar/table_calendar.dart';

class Shared extends ConsumerStatefulWidget {
  const Shared({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedState();
}

class _SharedState extends ConsumerState<Shared> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
          var expense = await ref.read(supabaseProvider).fetchAllExpenses();
          final expenses = expense[selectedDate] ?? [];
          ref.read(goRouterProvider).pushNamed("Display",
              extra: expenses,
              queryParameters: {'date': selectedDay.toIso8601String()});
        },
        shouldFillViewport: true,
        calendarFormat: CalendarFormat.month,
        onFormatChanged: (format) => CalendarFormat.week,
      ),
    );
  }
}
