import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_expense_tracker/components/expense_summary.dart';
import 'package:new_expense_tracker/components/expense_tile.dart';
import 'package:new_expense_tracker/data/expense_data.dart';
import 'package:new_expense_tracker/models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
      super.initState();

      // prepare data on startup
      Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new Expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense name",
              ),
            ),
            //expense amount
            Row(
              children: [
                // dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Dollars",
                    ),
                  ),
                ),
                // cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Cents",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // save
  void save() {
    // only save expense if the fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {
      // join dollars and cents
      String amount =
          '${newExpenseDollarController.text}.${newExpenseCentsController.text}';

      // create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      // add the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      Navigator.of(context).pop();
      clear();
    }
  }

  // cancel
  void cancel() {
    Navigator.of(context).pop();
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        // expense list
        body: ListView(
          children: [
            // weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(
              height: 20,
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpensesList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpensesList()[index].name,
                amount: value.getAllExpensesList()[index].amount,
                dateTime: value.getAllExpensesList()[index].dateTime,
                deleteTapped: (p0) => deleteExpense(
                  value.getAllExpensesList()[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
