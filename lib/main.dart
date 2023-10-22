import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:new_expense_tracker/data/expense_data.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a hive box
  await Hive.openBox('expense_database');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder: (context, child) => const MaterialApp(
        home: HomePage(),
      ),
    );
  }
} 