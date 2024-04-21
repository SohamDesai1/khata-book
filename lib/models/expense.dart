import 'package:hive_flutter/hive_flutter.dart';
part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final String item;
  @HiveField(2)
  final int price;

  Expense(this.date, this.item, this.price);
}
