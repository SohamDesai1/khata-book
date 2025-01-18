import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesMummy extends ConsumerStatefulWidget {
  const ExpensesMummy({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpensesMummyState();
}

class _ExpensesMummyState extends ConsumerState<ExpensesMummy> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("fjldfjal"),
      ),
    );
  }
}
