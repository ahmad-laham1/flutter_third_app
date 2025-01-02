import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpsense,
  });
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpsense;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            onRemoveExpsense(expenses[index]);
          },
          key: ValueKey(expenses[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.2),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          child: ExpenseItem(
            expenses[index],
          )), // this dismissible shit help you to swipe different things like notifications for example
    );
  }
}
