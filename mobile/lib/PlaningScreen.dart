import 'dart:math';
import 'dart:ui';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

AppMetricaConfig get _config => const AppMetricaConfig('c99878bb-5390-4f8e-8ad0-82b9b97cd60c', logs: true);

int plannedMonthlyExpenditure = 0;
List<Widget> planingCategories = [];
int curSum = Random().nextInt(2000);
List<DropdownMenuItem<String>> categories = [
  const DropdownMenuItem(child: Text("Транспорт"), value: "Транспорт"),
  const DropdownMenuItem(child: Text('Рестораны'), value: "Рестораны"),
];

class PlaningScreen extends StatefulWidget {
  const PlaningScreen({super.key});

  @override
  PlaningScreenState createState() => PlaningScreenState();
}

class PlaningScreenState extends State<PlaningScreen> {
  final TextEditingController sumController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String selectedCategory = "Транспорт";

  @override
  void initState() {
    AppMetrica.activate(_config);
    AppMetrica.reportEvent('Use app');
    categories.add(DropdownMenuItem(value: "Добавить",child: AddCategoryDialog(context)));
  }

  void changeCategoryPosition() {
    categories.add(DropdownMenuItem(value: "Добавить",child: AddCategoryDialog(context)));
    categories[categories.length - 2] = DropdownMenuItem(child: Text(categoryController.text), value: categoryController.text);
  }
  void addCategory() {
    setState(() {
      changeCategoryPosition();
    });

    categoryController.clear();
    Navigator.pop(context);
  }

  void addTransaction() {
    setState(() {
      planingCategories.add(transaction());
      plannedMonthlyExpenditure += int.parse(sumController.text);
    });

    sumController.clear();
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
      child: Center(
        child: ListTile(
          title: Text(selectedCategory, style: const TextStyle(fontSize: 14)),
          subtitle: LinearProgressIndicator(
            backgroundColor: const Color(0xffD0D0D0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff29AB87)),
            value: curSum / int.parse(sumController.text),

          ),
          trailing: Text(curSum.toString() + "/${sumController.text}", style: TextStyle(fontSize: 14)),
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
                      color: Color(0xffedf0f7),
                      border: Border.all(width: 2, color: Color(0xffedf0f7)),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: ClipRect(
                                  child: Image.asset('assets/boxes.png', width: 110, height: 62, alignment: Alignment.topLeft),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                child: Image.asset('assets/flower.png', width: 100, height: 62, alignment: Alignment.topLeft),
                              )
                            ],
                          )
                        ],
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(25, 5, 0, 0),
                          child: Text("Экономьте больше денег", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(25, 5, 0, 0),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text('Ваш план расходов', style: TextStyle(color: Color(0xff696969))),
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Row(
                                        children: [
                                          Text(plannedMonthlyExpenditure.toString(), style: TextStyle(fontSize: 22, color: Color(0xff696969), fontWeight: FontWeight.bold)),
                                          const Text('   /месяц', style: TextStyle(color: Color(0xff696969)))
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
                                        backgroundColor: Color(0xff5464c9),
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
            Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xfff6f7f9),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10)
                )
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text('Куда уходят ваши деньги?',
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold
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
                ],
              ),
            )
            )
            // const Row(
            //   children: [
            //     Padding(
            //         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            //         child: Text('Куда уходят ваши деньги?',
            //             style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
            //             )
            //         )
            //     ),
            //   ],
            // ),
            // Expanded(
            //   child: ListView.builder(
            //       itemCount: planingCategories.length,
            //       itemBuilder: (context,index){
            //         return planingCategories[index];
            //       }),
            // )
          ]
      ),
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
                          decoration: const InputDecoration(hintText: 'Планируeмая сумма'),
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
      icon: const Icon(Icons.add, color: Color(0xff5464c9),),

    );
  }

  Widget AddCategoryDialog(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Добавить категорию"),
                content:
                    TextField(
                      decoration:
                      const InputDecoration(hintText: 'Введите название'),
                      controller: categoryController,

                    ),
                actions: <Widget>[
                  TextButton(
                      onPressed: addCategory, child: const Text('Добавить')),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'))
                ],
              );
            });
          }), child: Text("Добавить"),
    );
  }
}