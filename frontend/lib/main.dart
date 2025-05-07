import 'package:flutter/material.dart';
import 'package:frontend/features/plans/screens/plans_list_screen.dart';
import 'app.dart';

void main() {
  runApp(const RunWithCoachApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunWithCoach',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const PlansListScreen(),
    );
  }
}
