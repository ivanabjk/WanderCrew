import 'package:flutter/material.dart';

class StartTripPage extends StatelessWidget {
  const StartTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('Start Trip page'); // This prints to the console when the widget builds

    return Scaffold(
      appBar: AppBar(title: const Text('Start Trip')),
      body: const Center(
        child: Text('Start Trip Page'),
      ),
    );
  }
}