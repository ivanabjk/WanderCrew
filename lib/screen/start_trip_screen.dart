import 'package:flutter/material.dart';

class StartTripScreen extends StatelessWidget {
  const StartTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Start Trip screen'); // This prints to the console when the widget builds

    return Scaffold(
      appBar: AppBar(title: const Text('Start Trip')),
      body: const Center(
        child: Text('Start Trip Screen'),
      ),
    );
  }
}