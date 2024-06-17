import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

int curCountOfAccounts = 4;
String selectedValue = "Личный";
List<DropdownMenuItem<String>> kindsOfAccounts = [
  const DropdownMenuItem(child: Text("Личный"), value: "Личный"),
  const DropdownMenuItem(child: Text('Семейный'), value: "Семейный"),
];
bool firstOpen = true;
List<CardContainer> accounts = [];

class LastTransaction extends StatefulWidget {
  const LastTransaction({super.key});

  @override
  LastTransactionState createState() => LastTransactionState();
}

class LastTransactionState extends State<LastTransaction> {
  List<Transaction> curTransaction = [];

  void fillAccounts() {
    accounts.add(Account(accountNumber: 1, accountName: "Личный" ,sumOnAccount: 2222,
        transactions: [
          Transaction(selectedCategory: 'Транспорт', sum: '165'),
          Transaction(selectedCategory: 'Рестораны', sum: '2057')
        ],
        callback: () {}
    ));

    accounts.add(Account(accountNumber: 2, accountName: "Личный выходной",sumOnAccount: 95738,
        transactions: [
          Transaction(selectedCategory: 'Транспорт', sum: '8578'),
          Transaction(selectedCategory: 'Рестораны', sum: '87160')
        ],
        callback: () {}
    ));

    accounts.add(FamilyAccount(accountNumber: 3,  accountName: "Семейный",sumOnAccount: 5432,
        transactions: [
          Transaction(selectedCategory: 'Транспорт', sum: '1489'),
          Transaction(selectedCategory: 'Рестораны', sum: '3943')
        ],
        callback: () {}
    ));

    accounts.add(CardContainer(accountNumber: 4, accountName: 'add', sumOnAccount: 0, transactions: [], callback: addAccount));
  }

  @override
  void initState() {
    super.initState();
    if (firstOpen) {
      fillAccounts();
      curCountOfAccounts = accounts.length;
    }

    curTransaction.clear();
    for(var i in accounts[0].transactions) {
      if (this.mounted) {
        setState(() {
          curTransaction.add(i);
        });
      }
    }

    firstOpen = false;
  }

  // void dispose() {
  //   super.dispose();
  // }

  void fillCurTransaction(List<Transaction> transactionsOnAccount) {
    curTransaction.clear();
    for(var i in transactionsOnAccount) {
      if (this.mounted) {
        setState(() {
          curTransaction.add(i);
        });
      }
    }
  }

  void addAccount(String name, double sum) {
    curCountOfAccounts++;
    if (this.mounted) {
      setState(() {
        if (selectedValue == "Личный") {
          accounts.add(Account(accountNumber: accounts.length,
              accountName: name,
              sumOnAccount: sum,
              transactions: [],
              callback: editAccount));
        } else {
          accounts.add(FamilyAccount(accountNumber: accounts.length,
              accountName: name,
              sumOnAccount: sum,
              transactions: [],
              callback: editAccount));
        }
      });
    }
  }

  void editAccount() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              padding: EdgeInsets.all(15),
              height: 225,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffe9e9f4),
                  border: Border.all(width: 2, color: Color(0xffe9e9f4)),
                  borderRadius: BorderRadius.circular(30)),
              child: Swiper(
                pagination: SwiperPagination(),
                itemCount: curCountOfAccounts,
                itemBuilder: (BuildContext context, int index) {
                  if (index < accounts.length) {
                    return Container(
                      child: accounts[index],
                    );
                  } else {
                    return Container();
                  }
                },
                viewportFraction: 0.8,
                scale: 0.9,
                onIndexChanged: (value) => fillCurTransaction(accounts[value].transactions),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
              height: 50,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff393a41),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)
                  )
              ),
              child: Center(
                  child: Container(
                      height: 35,
                      width: 180,
                      decoration: const BoxDecoration(
                          color: Color(0xff1c1c1e),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: const Center(
                        child: Text('Транзакции', style: TextStyle(color: Colors.white, fontSize: 20)),
                      )
                  )
              )
          ),
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xff393a41)
                  ),
                  child:ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Column(
                              children: [
                                for (var i in curTransaction)
                                  Container(
                                    child: i,
                                  )
                              ],
                            )
                        );
                      }
                  )
              )
          )
        ])
    );
  }
}

class CardContainer extends StatefulWidget {
  int accountNumber;
  double sumOnAccount;
  String accountName;
  List<Transaction> transactions = [];
  Function callback;

  CardContainer({required this.accountNumber, required this.accountName, required this.sumOnAccount, required this.transactions, required this.callback});

  @override
  CardContainerState createState() => CardContainerState(accountNumber: accountNumber, accountName: accountName, sumOnAccount: sumOnAccount, transactions: transactions, callback: callback);
}

class CardContainerState <T extends CardContainer> extends State<T> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sumController = TextEditingController();
  int accountNumber;
  double sumOnAccount;
  String accountName;
  List<Transaction> transactions = [];
  Function callback;

  void addAccount() {
    if (this.mounted) {
      Navigator.pop(context);
      widget.callback(nameController.text, double.parse(sumController.text));
    }
  }

  CardContainerState({required this.accountNumber, required this.accountName, required this.sumOnAccount, required this.transactions, required this.callback});

  Widget AddAccountDialog(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Добавить счет"),
                content: Column(
                  children: [
                    DropdownButton(
                      value: selectedValue,
                      items: kindsOfAccounts,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                    ),
                    TextField(
                      decoration:
                      const InputDecoration(hintText: 'Введите название'),
                      controller: nameController
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
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: addAccount, child: const Text('Добавить')),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff0a285d), width: 1),
        color: Color(0xff0a285d),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 44,
                  child: AddAccountDialog(context)
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Account extends CardContainer {
  Account({required super.accountNumber, required super.accountName, required super.sumOnAccount, required super.transactions, required super.callback});

  @override
  AccountState createState() => AccountState(accountNumber: accountNumber, accountName: accountName, sumOnAccount: sumOnAccount, transactions: transactions, callback: callback);
}

class AccountState extends CardContainerState<Account> {
  AccountState({required super.accountNumber, required super.accountName, required super.sumOnAccount, required super.transactions, required super.callback});

  // void editAccount(int curID) {
  //   if (this.mounted) {
  //     setState(() {
  //
  //     });
  //
  //   }
  // }
  //
  // void EditTransactionDialog(BuildContext context, String categoryName, String date, double sum) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text("Изменить счет"),
  //             content: Column(
  //               children: [
  //                 DropdownButton(
  //                   value: selectedValue,
  //                   items: kindsOfAccounts,
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       selectedValue = newValue!;
  //                     });
  //                   },
  //                 ),
  //                 TextField(
  //                     decoration:
  //                     const InputDecoration(hintText: 'Введите название'),
  //                     controller: nameController
  //                 ),
  //                 TextField(
  //                   decoration:
  //                   const InputDecoration(hintText: 'Введите сумму'),
  //                   controller: sumController,
  //                   keyboardType: TextInputType.number,
  //                   inputFormatters: <TextInputFormatter>[
  //                     FilteringTextInputFormatter.digitsOnly
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                   onPressed: () => editAccount(id), child: const Text('Изменить')),
  //               TextButton(
  //                   onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
  //               TextButton(
  //                   onPressed: () => removeAccount(id), child: const Text('Удалить', style: TextStyle(color: Colors.red)))
  //             ],
  //           );
  //         });
  //       }
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff0a285d), width: 1),
        color: Color(0xff0a285d),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(accountName, style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 15),
            Text(sumOnAccount.toString() + "₽", style: TextStyle(fontSize: 24, color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class FamilyAccount extends CardContainer {
  FamilyAccount({required super.accountNumber, required super.accountName, required super.sumOnAccount, required super.transactions, required super.callback});

  @override
  FamilyAccountState createState() => FamilyAccountState(accountNumber: accountNumber, accountName: accountName, sumOnAccount: sumOnAccount, transactions: transactions, callback: callback);
}

class FamilyAccountState extends CardContainerState<FamilyAccount> {
  FamilyAccountState({required super.accountNumber, required super.accountName, required super.sumOnAccount, required super.transactions, required super.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffffa362), width: 1),
        color: Color(0xffffa362),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(accountName, style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 15),
            Text(sumOnAccount.toString() + "₽", style: TextStyle(fontSize: 24, color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class Transaction extends StatelessWidget {
  late String selectedCategory;
  late String sum;

  Transaction({required this.selectedCategory, required this.sum});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff7e828b), width: 1),
        color: Color(0xff393a41),
      ),
      child: Center(
        child: ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xff393a41),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                  "https://img2.freepng.ru/20180721/plg/kisspng-computer-icons-rss-web-feed-blog-for-inspiration-and-recognition-of-science-and-tec-5b532bd6a76a01.8609731515321773666857.jpg"),
            ),
          ),
          title: Text(selectedCategory, style: TextStyle(fontSize: 20, color: Colors.white)),
          trailing:
          Text(sum + "₽", style: TextStyle(fontSize: 22, color: Colors.white)),
        ),
      ),
    );
  }

}



