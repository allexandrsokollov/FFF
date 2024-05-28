import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class LastTransaction extends StatefulWidget {
  const LastTransaction({super.key});

  @override
  LastTransactionState createState() => LastTransactionState();
}

class Account extends StatelessWidget {
  int accountNumber;
  int sumOnAccount;
  List<Transaction> transactions = [];

  Account({required this.accountNumber, required this.sumOnAccount, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff330066), width: 1),
        color: Color(0xff330066),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Счет " + accountNumber.toString(), style: TextStyle(fontSize: 18, color: Colors.white)),
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
          title: Text(selectedCategory, style: TextStyle(fontSize: 20)),
          trailing:
          Text(sum + "₽", style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

}

class LastTransactionState extends State<LastTransaction> {
  List<Account> accounts = [
    Account(accountNumber: 1, sumOnAccount: 2222,
      transactions: [
        Transaction(selectedCategory: 'Транспорт', sum: '165'),
        Transaction(selectedCategory: 'Рестораны', sum: '2057')
      ],
    ),
    Account(accountNumber: 2, sumOnAccount: 95738,
      transactions: [
        Transaction(selectedCategory: 'Транспорт', sum: '8578'),
        Transaction(selectedCategory: 'Рестораны', sum: '87160')
      ],
    ),
    Account(accountNumber: 3, sumOnAccount: 5432,
      transactions: [
        Transaction(selectedCategory: 'Транспорт', sum: '1489'),
        Transaction(selectedCategory: 'Рестораны', sum: '3943')
      ],
    )
  ];

  List<Transaction> curTransaction = [];

  void fillCurTransaction(List<Transaction> transactionsOnAccount) {
    curTransaction.clear();
    for(var i in transactionsOnAccount) {
      setState(() {
        curTransaction.add(i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                height: 225,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xffdbe6fb),
                    border: Border.all(width: 2, color: Color(0xffdbe6fb)),
                    borderRadius: BorderRadius.circular(30)),
                child: Swiper(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: accounts[index],
                    );
                  },
                  viewportFraction: 0.8,
                  scale: 0.9,
                  onIndexChanged: (value) => fillCurTransaction(accounts[value].transactions),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text('Транзакции',
              style: TextStyle(color: Color(0xff330066), fontSize: 20)),
          Expanded(
              child: ListView.builder(
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
        ])
    );
  }
}



