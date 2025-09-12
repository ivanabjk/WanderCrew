import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('Register page'); // This prints to the console when the widget builds

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(
        child: Text('Register Page'),
      ),
    );
  }
}