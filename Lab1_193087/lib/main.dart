import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 - 193087',
      theme: new ThemeData(scaffoldBackgroundColor: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('193087 Димитарчо Донев'),
        ),
      ),
    );
  }
}
