import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('Map page'); // This prints to the console when the widget builds

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: const Center(
        child: Text('Map Page'),
      ),
    );
  }
}