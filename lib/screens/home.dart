import 'package:flutter/material.dart';
import 'display.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _countController = TextEditingController();
  final Map<TextEditingController, Map<String, dynamic>> players = {};

  @override
  void dispose() {
    // Dispose of the count controller
    _countController.dispose();

    // Dispose of all player controllers
    for (var playerData in players.keys) {
      playerData.dispose();
    }
    super.dispose();
  }

  void _generateTextFields(int count) {
    // Clear existing controllers
    for (var playerData in players.keys) {
      playerData.dispose();
    }
    players.clear();

    // Generate new controllers
    for (int i = 0; i < count; i++) {
      final playerNameController = TextEditingController();
      // final playerAmountController = TextEditingController();
      players[playerNameController] = {
        'name': '',
        'amount': '',
        'result': 'profit'
      };
    }
    setState(() {});
  }

  // void _logPlayerResults() {
  //   players.forEach((controller, playerData) {
  //     final name = playerData['name'];
  //     final amount = playerData['amount'];
  //     final result = playerData['result'];
  //     log('Player: $name, Amount: $amount, Result: $result');
  //   });
  //   _allocatePayments();
  // }

  List _allocatePayments() {
    final List<Map<String, dynamic>> winners = [];
    final List<Map<String, dynamic>> losers = [];

    players.forEach((controller, playerData) {
      if (playerData['result'] == 'profit') {
        winners.add(playerData);
      } else {
        losers.add(playerData);
      }
    });

    final payments = [];

    for (var winner in winners) {
      for (var loser in losers) {
        // Convert amounts to integers
        int winnerAmount = int.parse(winner['amount']);
        int loserAmount = int.parse(loser['amount']);

        if (winnerAmount > 0 && loserAmount > 0) {
          if (winnerAmount == loserAmount) {
            payments
                .add('${loser['name']} pays ${winner['name']} $winnerAmount');
            winner['amount'] = '0'; // Mark this amount as settled
            loser['amount'] = '0'; // Mark this amount as settled
          } else if (winnerAmount > loserAmount) {
            payments
                .add('${loser['name']} pays ${winner['name']} $loserAmount');
            winner['amount'] = (winnerAmount - loserAmount).toString();
            loser['amount'] = '0'; // Mark this amount as settled
          } else {
            payments
                .add('${loser['name']} pays ${winner['name']} $winnerAmount');
            loser['amount'] = (loserAmount - winnerAmount).toString();
            winner['amount'] = '0'; // Mark this amount as settled
          }
        }
      }
    }

    // Handle any remaining losers with unaccounted amounts
    for (var loser in losers) {
      if (int.parse(loser['amount']) > 0) {
        payments.add(
            '${loser['name']} still has an amount of ${loser['amount']} that is not accounted for.');
      }
    }

    // Print out all payments
    return payments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Royal Club')),
      body: Column(
        children: [
          TextField(
            controller: _countController,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Enter number of players'),
            onSubmitted: (value) {
              final count = int.tryParse(value) ?? 0;
              _generateTextFields(count);
            },
          ),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final playerNameController = players.keys.elementAt(index);
                final playerData = players[playerNameController]!;
                final playerAmountController = TextEditingController();
                playerAmountController.text = playerData['amount'] ?? '';

                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: playerNameController,
                        decoration:
                            InputDecoration(labelText: 'Player ${index + 1}'),
                        onChanged: (value) {
                          players[playerNameController]!['name'] = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: playerAmountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        onChanged: (value) {
                          players[playerNameController]!['amount'] = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: playerData['result'],
                      onChanged: (String? newValue) {
                        setState(() {
                          players[playerNameController]!['result'] = newValue!;
                        });
                      },
                      items: <String>['profit', 'loss']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              var results = _allocatePayments();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Display(results: results),
              ));
            },
            child: const Text('Log Player Results'),
          ),
        ],
      ),
    );
  }
}

