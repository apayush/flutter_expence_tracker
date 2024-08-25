import 'package:expence_tracker/components/expense_summary.dart';
import 'package:expence_tracker/components/expense_tile.dart';
import 'package:expence_tracker/data/expense_data.dart';
import 'package:expence_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {

  //text controller
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expanse Name"
              ),
            ),
            
            Row(children: [
              //dollars
              Expanded(
                child: TextField(
                  controller: newExpenseDollarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Rupees"
                  ),
                ),
              ),

              //cents
              Expanded(
                child: TextField(
                  controller: newExpenseCentsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Paisa",
                  ),
                ),                
              ),
            ],),
            //expense amount
          ],
          ),
          actions: [
            //save button
            MaterialButton(onPressed: save, child: Text('Save'),),

            //cancel button
            MaterialButton(onPressed: cancel, child: Text('Cancel'),)
          ],
      )
      );
  }

  //delete expense
   void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
   }
  //save
   void save() {

    //only save expense if all fields are filled
    if(newExpenseNameController.text.isNotEmpty && newExpenseDollarController.text.isNotEmpty) {
      //put dollars and cents together
    String amount = '${newExpenseDollarController.text}.${newExpenseCentsController.text}';

    //create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text, 
      amount: amount, 
      dateTime: DateTime.now(),
      );
      //add the new Expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }
    

    Navigator.pop(context);
    clear();
   }
  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseDollarController.clear();
    newExpenseNameController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ExpenseData>(
      builder : (context,value,child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Color.fromARGB(255, 122, 169, 193),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        
        appBar: AppBar(
        title: const Text("Weekly Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 122, 169, 193),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.attach_money_sharp,color: Colors.black,),
          ),],
      ),
        body: 
        ListView(
          children:[ 
            //weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(height: 20),
            //expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name, 
                amount: value.getAllExpenseList()[index].amount, 
                dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: (p0) => deleteExpense(value.getAllExpenseList()[index]),
                )
            ),
          ]
        ),
      ),
    );
  }
}