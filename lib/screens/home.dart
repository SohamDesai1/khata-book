// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supabase_ops.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
                    onPressed: () {
                      ref
                          .read(supabaseProvider)
                          .saveToSupabase(context, samaan, _countController);
                      ref.read(supabaseProvider).onStateChange = () {
                        samaan.clear();
                        toshowb = false;
                      };
                    },
                    child: const Text("Save"))
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
