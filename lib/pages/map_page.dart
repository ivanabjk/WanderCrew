import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

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