import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:app_planning_budget/LastTransactionScreen.dart';

int id = 0;
double curSum = 10;
String selectedCategory = "Транспорт";
String selectedAccount = "Личный";
List<DropdownMenuItem<String>> accountsName = [];
List<Transaction> transactions = [];
bool firstOpen = true;


void fillAccountsName() {
  List<String> resList = [];
  accountsName.clear();
  for (int i = 0; i < accounts.length - 1; i++) {
    resList.add(accounts[i].accountName);
  }

  for (String str in resList) {
    accountsName.add(DropdownMenuItem(child: Text(str), value: str));
  }
}

List<DropdownMenuItem<String>> categories = [
  DropdownMenuItem(child: Text("Транспорт"), value: "Транспорт"),
  DropdownMenuItem(child: Text('Рестораны'), value: "Рестораны")
];


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final TextEditingController sumController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    fillAccountsName();
    if (firstOpen) {
      transactions.add(Transaction(id: 0,
          categoryName: selectedCategory,
          sum: 10,
          date: DateFormat('dd MMMM yyyy').format(DateTime.parse('20240529')),
          account: selectedAccount,
          callback: editTransaction));
    }
    transactions.sort((a, b) => a.date.compareTo(b.date));
    firstOpen = false;
  }

  void addTransaction() {
    setState(() {
      transactions.add(Transaction(id: id, categoryName: selectedCategory, sum: double.parse(sumController.text), date: dateController.text, account: selectedAccount, callback: editTransaction));
      // transactions.sort((a, b) => a.date.compareTo(b.date));
    });

    selectedCategory = "Транспорт";
    dateController.clear();
    sumController.clear();
    id++;

    Navigator.pop(context);

    //sumController.dispose();
  }

  void editTransaction(int curID, Transaction tr, bool isRemove) {
    if (!isRemove) {
      setState(() {
        transactions[curID] = tr;
      });

      curSum += tr.sum;
    } else {
      curSum -= transactions[curID].sum;
      setState(() {
        transactions.removeAt(curID);
      });
    }
    selectedCategory = "Транспорт";
    dateController.clear();
    sumController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (Transaction tr in transactions) {

    };
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xfff3f3f9),
                  border: Border.all(width: 2, color: Color(0xfff3f3f9)),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text('Общие расходы',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey)),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 0, 0),
                        child: Text('за день',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 0, 0),
                        child: Text('$curSum ₽',
                            style: const TextStyle(
                                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
                        child: Text('Оставшийся',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 15, 0),
                        child: Text('баланс',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 15, 0),
                        child: Text('8 924 ₽',
                            style: TextStyle(
                                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              )),
        ),

        Row(
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text('Транзакции',
                    style: TextStyle(color: Colors.black, fontSize: 18))),
            const Spacer(),
            CircleAvatar(
                backgroundColor: Color(0xff6273cc),
                radius: 16,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: AddTransactionDialog(context))),
            const SizedBox(width: 10),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text('Добавить',
                    style: TextStyle(color: Color(0xff919191), fontSize: 16))),
          ],
        ),
        Expanded(
          // child: transactions[0],
          child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (_, index) {
            bool isSameDate = true;
            // transactions.sort((a, b) => a.date.compareTo(b.date));
            final String dateString = transactions[index].date;
            final DateTime date = DateTime.parse(convertDate(dateString));
            if (index == 0) {
            isSameDate = false;
            } else {
            final String prevDateString = transactions[index - 1].date;
            final DateTime prevDate = DateTime.parse(convertDate(prevDateString));
            isSameDate = date.isSameDate(prevDate);
            }
            if (index == 0 || !(isSameDate)) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child:Text(date.formatDate(), style: TextStyle(fontSize: 16, color: Color(0xff4b5668), fontWeight: FontWeight.bold))
            ),
              transactions[index]
            ]);
            } else {
            return transactions[index];
            }
            }
        ))
      ]),
    );
  }


  Widget AddTransactionDialog(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Добавить операцию"),
                content: Column(
                  children: [
                    DropdownButton(
                      value: selectedCategory,
                      items: categories,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                    DropdownButton(
                      value: selectedAccount,
                      items: accountsName,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAccount = newValue!;
                        });
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(hintText: 'Введите сумму'),
                      controller: sumController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    Center(
                      child: TextField(
                        readOnly: true,
                        controller: dateController,
                        decoration:
                            const InputDecoration(hintText: 'Выберите дату'),
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            dateController.text =
                                DateFormat('dd MMMM yyyy').format(date);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: addTransaction, child: const Text('Добавить')),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'))
                ],
              );
            });
          }),
      icon: const Icon(Icons.add, color: Color(0xff6273cc)),
    );
  }
}

String convertDate(String inputDate) {
  DateFormat inputFormat = DateFormat('dd MMMM yyyy');
  DateTime dateTime = inputFormat.parse(inputDate);
  DateFormat outputFormat = DateFormat('yyyyMMdd');
  String outputDate = outputFormat.format(dateTime);

  return outputDate;
}

const String dateFormatter = 'dd MMMM yyyy';

extension DateHelper on DateTime {

  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}

class Transaction extends StatefulWidget {
  // Transaction({required super.id, required super.categoryName, required super.sum, required super.date, required super.callback});

  final int id;
  late String categoryName;
  late double sum;
  String date;
  Function callback;
  String account;

  Transaction({required this.id, required this.categoryName, required this.sum, required this.date, required this.account, required this.callback});

  @override
  TransactionState createState() => TransactionState(id: id, categoryName: categoryName, sum: sum, date: date, account: account);
}

class TransactionState extends State<Transaction> {
  final TextEditingController sumController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final int id;
  late String categoryName;
  late double sum;
  String date;
  String account;

  TransactionState({required this.id, required this.categoryName, required this.sum,  required this.account, required this.date});

  void editTransaction(int curID) {
    setState(() {
      transactions[curID] = Transaction(id: curID, categoryName: selectedCategory, sum: double.parse(sumController.text), date: dateController.text, account: account, callback: editTransaction);
    });
    Transaction tr = Transaction(id: curID, categoryName: selectedCategory, sum: double.parse(sumController.text), date: dateController.text, account: account, callback: editTransaction);
    Navigator.pop(context);
    widget.callback(curID, tr, false);
  }

  void removeTransaction(int curID) {
    setState(() {

    });
    Transaction tr = Transaction(id: curID, categoryName: selectedCategory, sum: 0, date: '20020101', account: account, callback: editTransaction);
    Navigator.pop(context);
    widget.callback(curID, tr, true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff696969), width: 1),
        color: Colors.white,
      ),
      child: Center(
        child: ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                  "https://img2.freepng.ru/20180721/plg/kisspng-computer-icons-rss-web-feed-blog-for-inspiration-and-recognition-of-science-and-tec-5b532bd6a76a01.8609731515321773666857.jpg"),
            ),
          ),
          title: Text(categoryName, style: TextStyle(fontSize: 20)),
          subtitle: Text(date.toString(), style: TextStyle(fontSize: 16)),
          trailing: Column(
            children: [
              Text(sum.toString() + "₽", style: TextStyle(fontSize: 22)),
              Text(account, style: TextStyle(fontSize: 16))
            ],
          ), //Text(sum.toString() + "₽", style: TextStyle(fontSize: 22)),
          onTap: () => EditTransactionDialog(context, categoryName, date.toString(), sum),
        ),
      ),
    );
  }

  void EditTransactionDialog(BuildContext context, String categoryName, String date, double sum) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Изменить операцию"),
              content: Column(
                children: [
                  DropdownButton(
                    value: categoryName,
                    items: categories,
                    onChanged: (String? newValue) {
                      setState(() {
                        categoryName = newValue!;
                      });
                    },
                  ),
                  TextField(
                    decoration:
                    const InputDecoration(hintText: 'Введите сумму'),
                    controller: sumController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  Center(
                    child: TextField(
                      readOnly: true,
                      controller: dateController,
                      decoration:
                      const InputDecoration(hintText: 'Выберите дату'),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          dateController.text =
                              DateFormat('dd MMMM yyyy').format(date);
                        }
                      },
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => editTransaction(id), child: const Text('Изменить')),
                TextButton(
                    onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                TextButton(
                    onPressed: () => removeTransaction(id), child: const Text('Удалить', style: TextStyle(color: Colors.red)))
              ],
            );
          });
        }
    );
  }
}