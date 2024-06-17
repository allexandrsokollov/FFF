import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class Transaction extends StatelessWidget {
  late String selectedCategory;
  late String sum;
  String month;

  Transaction({required this.selectedCategory, required this.sum, required this.month});

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
          subtitle: Text(month, style: TextStyle(fontSize: 16)),
          trailing: Text(sum + "₽", style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Transaction> transactions = [
        Transaction(selectedCategory: 'Транспорт', sum: '10232', month: 'Март'),
        Transaction(selectedCategory: 'Рестораны', sum: '93160', month: 'Апрель',)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Мои расходы'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<TransactionData, String>> [
              SplineSeries<TransactionData, String>(
              // LineSeries<TransactionData, String>(
                dataSource: <TransactionData>[
                  TransactionData('Март', 10232),
                  TransactionData('Апрель', 93160),
                  TransactionData('Июнь', 45300),
                ],
                xValueMapper: (TransactionData sum, _) => sum.month,
                yValueMapper: (TransactionData sum, _) => sum.sum,
                name: 'Расходы',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )

            ],
          ),
          Container(
            height: 80,
            margin: const EdgeInsets.only(top: 5,left: 8,right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xff718096), width: 1),
              color: Color(0xff718096),
            ),
            child: const ListTile(
              title: Text("Бюджет на апрель", style: TextStyle(fontSize: 18, color: Colors.white)),
              subtitle: LinearProgressIndicator(
                backgroundColor: Color(0xffD0D0D0),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                value: 93160 / 102320,
              ),
              trailing: Text("102320", style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Мои расходы',
                    style: TextStyle(color: Color(0xff330066), fontSize: 20)),
            )
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                        child: Column(
                          children: [
                            for (var i in transactions)
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

class TransactionData {
  TransactionData(this.month, this.sum);

  final String month;
  final int sum;
}



