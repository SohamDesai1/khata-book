import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final List results;
  const Display({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 400,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(results[index]),
                );
              },
              itemCount: results.length,
            ),
          ),
        ),
      ),
    );
  }
}