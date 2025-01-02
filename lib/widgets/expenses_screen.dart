import "package:flutter/material.dart";
import "package:third_app/widgets/expenses_list/expenses_list.dart";
import "package:third_app/models/expense.dart";
import "package:third_app/widgets/new_expense.dart";
import 'package:third_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _openAddExpeneseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
    //thats a function + when you see a builder as a parameter it means that you need to pass a function
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removedExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Text('Expense deleted.'),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }), //sometimes you need to use this action shit to undo something for example
    )); //we are using this snackBar shit to notify the user that he deleted he fucking expense
  }

  // you use ()=> when the function will only return something and will not excute any code
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent =
        const Center(child: Text('No expenses found. Start adding some!'));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpsense: _removedExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpeneseOverlay,
              icon: Icon(Icons
                  .add)) //we didn't add the () so the function do not excuite except when the button is pressed :)
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),

                  ///we wrap the Chart widget inside Expanded widget because the chart widget is trying to take as much width as it cans and the Row widget(the parent of the chart widget) is trying to do the same thing and that make a problem and we can solve it by wraping the chart widget inside expanded :)
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
