import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Widget> transactions = [];

  void addTransaction() {
    setState(() {
      transactions.add(transaction());
    });
  }

  Widget transaction() {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 5,left: 8,right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:Colors.orangeAccent[100],
      ),
      child: Center(
        child: ListTile(
          leading: const CircleAvatar(
            radius : 28 ,
            backgroundColor:  Colors.white ,
            child: CircleAvatar(
              radius:  26,
              backgroundImage:  NetworkImage(
                  "https://i.pinimg.com/originals/71/83/70/7183704aac01413c86805c19c1586e2b.jpg"),
            ),
          ),
          title: const Text(
            "Freedom Fighter",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.deepPurple),
          ),
          subtitle: const Text(
            'Freedom Fighter',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white),
          ),
          trailing: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 50,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('5',
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey)),
                    SizedBox(
                      width: 1,
                    ),
                    Icon(
                      Icons.access_alarms_outlined,
                      textDirection: TextDirection.rtl,
                      size: 20,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context,index){
              return transactions[index];
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTransaction,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar (
        items: const [
          BottomNavigationBarItem(label: 'Домой',icon: Icon(Icons.home_sharp, color: Color(0xff330066))),
          BottomNavigationBarItem(label: 'Аналитика', icon: Icon(Icons.incomplete_circle_outlined, color: Color(0xff330066))),
          BottomNavigationBarItem(label: 'Последние транзакции', icon: Icon(Icons.compare_arrows,  color: Color(0xff330066))),
          BottomNavigationBarItem(label: 'Планирование бюджета', icon: Icon(Icons.trending_up,  color: Color(0xff330066))),
          BottomNavigationBarItem(label: 'Профиль', icon: Icon(Icons.person,  color: Color(0xff330066)))
        ],
        ),
    );
  }
}