import 'package:flutter/material.dart';
import 'package:new_expense_tracker/components/expense_tile.dart';
import 'package:new_expense_tracker/data/expense_data.dart';
import 'package:new_expense_tracker/models/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  // add new Expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
            ),
            //expense amount
            TextField(controller: newExpenseAmountController),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // save
  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );

    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.of(context).pop();
    clear();
  }

  // cancel
  void cancel() {
    Navigator.of(context).pop();
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: Icon(Icons.add),
        ),
        // expense list
        body: ListView.builder(
          itemCount: value.getAllExpensesList().length,
          itemBuilder: (context, index) => ExpenseTile(
            name: value.getAllExpensesList()[index].name,
            amount: value.getAllExpensesList()[index].amount,
            dateTime: value.getAllExpensesList()[index].dateTime,
          ),
        ),
      ),
    );
  }
}
