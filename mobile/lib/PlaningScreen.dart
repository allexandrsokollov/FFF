import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlaningScreen extends StatefulWidget {
  const PlaningScreen({super.key});

  @override
  PlaningScreenState createState() => PlaningScreenState();
}

class PlaningScreenState extends State<PlaningScreen> {
  List<Widget> planingCategories = [];
  final TextEditingController sumController = TextEditingController();
  String selectedCategory = "Транспорт";

  List<DropdownMenuItem<String>> categories = [
    const DropdownMenuItem(child: Text("Транспорт"), value: "Транспорт"),
    const DropdownMenuItem(child: Text('Рестораны'), value: "Рестораны")
  ];

  void addTransaction() {
    setState(() {
      planingCategories.add(transaction());
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget transaction() {

    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 5,left: 8,right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff696969), width: 1),
        color: Colors.white,
      ),
      child: Center(
        child: ListTile(
          leading: const CircleAvatar(
            radius : 28 ,
            backgroundColor:  Colors.white ,
            child: CircleAvatar(
              radius:  26,
              backgroundImage:  NetworkImage(
                  "https://img2.freepng.ru/20180721/plg/kisspng-computer-icons-rss-web-feed-blog-for-inspiration-and-recognition-of-science-and-tec-5b532bd6a76a01.8609731515321773666857.jpg"),
            ),
          ),
          title: Text(selectedCategory, style: const TextStyle(fontSize: 18)),
          subtitle: LinearProgressIndicator(
            backgroundColor: const Color(0xffD0D0D0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff29AB87)),
            value: 1032 / int.parse(sumController.text),

          ),
          trailing: Text("1 032/${sumController.text}", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffdbe6fb),
                      border: Border.all(width: 2, color: Color(0xffdbe6fb)),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                    children: [
                      // Здесь будут картинки
                      // Container(
                      //   width: 100,
                      //   height: 30,
                      //   decoration: const BoxDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage('https://e7.pngegg.com/pngimages/865/934/png-clipart-decorative-box-kraft-paper-packaging-and-labeling-box-miscellaneous-cardboard.png')
                      //     )
                      //   ),
                      // ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Text("Экономьте больше денег", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Text("Улучшите план для большой экономии", style: TextStyle(fontSize: 14, color: Color(0xff696969))),
                        ),
                      ),
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.all(5),
                        child:Container(
                          height: 115,
                          width: 330,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Color(0xffDCDCDC)),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child:  Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text('Ваш план расходов', style: TextStyle(color: Color(0xff696969))),
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Row(
                                        children: [
                                          Text('40 000', style: TextStyle(fontSize: 22, color: Color(0xff696969))),
                                          Text('   /месяц', style: TextStyle(color: Color(0xff696969)))
                                        ],
                                      )
                                  )
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 30, 65, 0),
                                    child:                                   CircleAvatar(
                                        backgroundColor: Color(0xff330066),
                                        radius: 16,
                                        child:  CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 14,
                                            child: AddTransactionDialog(context)
                                        )
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                                    child: Text('Добавить категорию', style: TextStyle(color: Color(0xff696969))),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                                    child: Text('для плана', style: TextStyle(color: Color(0xff696969))),
                                  )
                                ],
                              )
                            ]
                          )
                        ),
                      )
                    ],
                  )
              ),
            ),
            const Row(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text('Куда уходят ваши деньги?',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                        )
                    )
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: planingCategories.length,
                  itemBuilder: (context,index){
                    return planingCategories[index];
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
            return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text("Добавить операцию"),
                    content: Column(
                      children: [
                        DropdownButton(
                          value: selectedCategory,
                          items: categories,
                          onChanged: (String? newValue) {
                            setState((){
                              selectedCategory = newValue!;
                            });
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: 'Планирумая сумма'),
                          controller: sumController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(onPressed: addTransaction, child: const Text('Добавить')),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена'))
                    ],
                  );
                }
            );
          }
      ),
      icon: const Icon(Icons.add),

    );
  }
}



