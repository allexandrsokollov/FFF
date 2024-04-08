import 'package:app_planning_budget/LastTransactionScreen.dart';
import 'package:app_planning_budget/MainScreen.dart';
import 'package:flutter/material.dart';
import 'ProfileScreen.dart';
import 'PlaningScreen.dart';

class Pages extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Pages> {
  int _currentIndex = 0;
  final List<Widget> _pages = [];
  @override
  void initState() {
    _pages.add(const MainScreen());
    _pages.add(SettingScreen());
    _pages.add(const LastTransaction());
    _pages.add(const PlaningScreen());
    _pages.add(const ProfileScreen());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('FFF'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Color(0xff330066),
          unselectedItemColor: Color(0xff330066),
          selectedItemColor: Color(0xff330066),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: 'Дом'),
            BottomNavigationBarItem(label: 'Аналитика', icon: Icon(Icons.incomplete_circle_outlined, color: Color(0xff330066))),
            BottomNavigationBarItem(label: 'Расходы', icon: Icon(Icons.compare_arrows,  color: Color(0xff330066))),
            BottomNavigationBarItem(label: 'Бюджет', icon: Icon(Icons.trending_up,  color: Color(0xff330066))),
            BottomNavigationBarItem(label: 'Профиль', icon: Icon(Icons.person,  color: Color(0xff330066)))
          ]),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Home')),
    );
  }
}
class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Category')),
    );
  }
}
class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Settings')),
    );
  }
}