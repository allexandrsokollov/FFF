import 'package:flutter/material.dart';
import 'OpeningScreen.dart';

void main() {
  runApp(MainPages());
}

// Возможно, здесь потом будет проверка на авторизованного пользователя и в зависимости
// от этого будет открываться начальный экран либо регистрация, либо уже стартовая страница
class MainPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: OpeningScreen()
    );
  }

}



