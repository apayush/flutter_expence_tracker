import 'package:expence_tracker/data/hive_database.dart';
import 'package:expence_tracker/datetime/date_time_helper.dart';
import 'package:expence_tracker/models/expense_item.dart';

//import 'dart:math';

import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier{

  //list all the expenses
  List<ExpenseItem> overallExpenseList = [];
  
  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

    //prepare data to display
    final db = HiveDatabase();
    void prepareData() {
      //if there exists data get it
      if(db.readData().isNotEmpty) {
        overallExpenseList = db.readData();
      }
    }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday from datetime object
  String getDayName(DateTime datetime) {
    switch (datetime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  //get the date for the start of the week
  DateTime startOfWeekDate(){
    DateTime? startOfWeek;
    
    //get today date
    DateTime today = DateTime.now();

    //go backward from today to find sunday
    for (int i=0;i<7;i++) {
      if(getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }


  Map<String,double> calculateDailyExpenseSummary() {
    Map<String,double> dailyExpenseSummary = {
      //date (yyyymmdd) : amountTotal Foe Day

    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount; 
      } 
      else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}