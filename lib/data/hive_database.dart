import 'package:expence_tracker/models/expense_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase{
  //reference our box
  final _myBox = Hive.box("expanse_database2");

  //write data
  void saveData(List<ExpenseItem> allExpense) {
    
    List<List<dynamic>> allExpenseFormatted = [];

    for(var expense in allExpense) {
      // convert each item into a list pf storable type string and datetime
      List<dynamic> expenseFormatted =[
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    //finally lets store in our database
    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  //read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for(int i=0; i<savedExpenses.length;i++) {
      //collect expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expense item

      ExpenseItem expense = 
          ExpenseItem(
            name: name, 
            amount: amount, 
            dateTime: dateTime,
        );

        //add expense to overall list of expenses
        allExpenses.add(expense);
    }

    return allExpenses;
  }
}