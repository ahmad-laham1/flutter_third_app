import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:third_app/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

// !!!!!!!!!!!!!!!-very important note-!!!!!!!!!!!! you _NewExpense can have access to NewExpense attributes and methods by using the widget property provided by dart

class _NewExpense extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime?
      _selectedDate; // we put the question mark to tell dart that _selectedDate will hold a date that is selected by the user or it will hold nothing(null)
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
    // .then((value) {
    // }); // built-in flutter function and that is the first way to store the date that the user will pick and the second way is using (async with await)
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text("Invalid input"),
                content: Text(
                    "Please make sure a valid title, amount, date and category was enterd."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text("Okay"))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid input"),
                content: Text(
                    "Please make sure a valid title, amount, date and category was enterd."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text("Okay"))
                ],
              ));
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return; //rememeber when ever you see a builder that means that you need to put a parameter
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date:
            _selectedDate!, //again this ! to tell dart that _selectedDate will never be null because you validatedbefore
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super
        .dispose(); //we need to delete the _titleController when there is no use for it so we cane save memory space
  }

  //note: only "state classes can impolement this "dispose" method (statelesswidget can't). that's also why you must use a statefulwidget here.

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller:
                              _titleController, //multiple fields need multiple controllers (a controller for each field)
                          decoration: const InputDecoration(
                              label: Text(
                                  "Title:")), // we add the label for the input field by adding a decoration
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                              label: Text('Amount:'), prefixText: '\$'),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller:
                        _titleController, //multiple fields need multiple controllers (a controller for each field)
                    decoration: const InputDecoration(
                        label: Text(
                            "Title:")), // we add the label for the input field by adding a decoration
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase())),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(
                                  _selectedDate!)), //we add the explanation mark (!) at the end to force dart to assume that(_selectedDate) will never be null
                          IconButton(
                            icon: Icon(Icons.calendar_month),
                            onPressed: _presentDatePicker,
                          )
                        ],
                      )),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                            label: Text('Amount:'), prefixText: '\$'),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(
                                  _selectedDate!)), //we add the explanation mark (!) at the end to force dart to assume that(_selectedDate) will never be null
                          IconButton(
                            icon: Icon(Icons.calendar_month),
                            onPressed: _presentDatePicker,
                          )
                        ],
                      ))
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase())),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}

// when use row inside a row or if you have problems related to nested rows/columns use the expand widget to solve this problem
