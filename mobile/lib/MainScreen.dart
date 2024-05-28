import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Widget> transactions = [];
  final TextEditingController sumController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedCategory = "Транспорт";

  List<DropdownMenuItem<String>> categories = [
    DropdownMenuItem(child: Text("Транспорт"), value: "Транспорт"),
    DropdownMenuItem(child: Text('Рестораны'), value: "Рестораны")
  ];

  void addTransaction() {
    setState(() {
      transactions.add(transaction());
    });

    Navigator.pop(context);

    //sumController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget transaction() {
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
          subtitle: Text(dateController.text, style: TextStyle(fontSize: 12)),
          trailing:
              Text(sumController.text + "₽", style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xffdbe6fb),
                  border: Border.all(width: 2, color: Color(0xffdbe6fb)),
                  borderRadius: BorderRadius.circular(30)),
              child: const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                        child: Text('Общие расходы',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff330066))),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 0, 0),
                        child: Text('за день',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff330066))),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 2, 0, 0),
                        child: Text('4 123',
                            style: TextStyle(
                                fontSize: 30, color: Color(0xff330066))),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
                        child: Text('Оставшийся',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff330066))),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 15, 0),
                        child: Text('баланс',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff330066))),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 15, 0),
                        child: Text('8 924',
                            style: TextStyle(
                                fontSize: 30, color: Color(0xff330066))),
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
                    style: TextStyle(color: Color(0xff330066), fontSize: 16))),
            const Spacer(),
            CircleAvatar(
                backgroundColor: Color(0xff330066),
                radius: 16,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: AddTransactionDialog(context))),
            const SizedBox(width: 10),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text('Добавить',
                    style: TextStyle(color: Color(0xff330066), fontSize: 16))),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return transactions[index];
              }),
        )
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
      icon: const Icon(Icons.add),
    );
  }
}
