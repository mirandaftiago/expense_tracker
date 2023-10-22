import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDatabase {
  // reference our box
  final _myBox = Hive.box('expense_database');

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    /*
    Hive can only store strings and dateTime, and not custom objects like ExpenseItem.
    So lets convert the ExpenseItem into types that can be stored in the db.
    */

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      // convert each expenseItem into a list of storable types (strings, dateTime)
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];

      allExpensesFormatted.add(expenseFormatted);

      // store in db
      _myBox.put('ALL EXPENSES', allExpensesFormatted);
    }
  }

  // read data
  List<ExpenseItem> readData() {
    /*
    Data is stored in Hive as a list of strings + dateTime,
    so let's convert our saved data into ExpenseItem objects
    */

    List savedExpenses = _myBox.get('ALL EXPENSES') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense item
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expense to overall list of expenses
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
