import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selected = DateTime.now();
  String month = "";
  String date = "";
  handleClick() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Column(
              children: [
                const Text("Add Expense"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selected,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selected = pickedDate;
                          });
                          debugPrint(selected.toString());
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          SizedBox(
                            width: 2.w,
                          ),
                          // Text("$date,$month")
                          Text(
                              "${DateFormat.E().format(selected)}, ${DateFormat.yMMMd().format(selected)}")
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Your Expenses'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: handleClick, child: const Icon(Icons.add)),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
