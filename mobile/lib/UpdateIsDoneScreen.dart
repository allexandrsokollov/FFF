import 'package:app_planning_budget/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class UpdateIsDoneScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 const Text("Пароль обновлен", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff330066))),
                 const SizedBox(height: 10),
                 const Text("Ваш пароль успешно изменен", style: TextStyle(fontSize: 16, color: Color(0xff330066))),
                  const SizedBox(height: 25),
                  BackButton()
               ],
            )
    );
  }
}

void goToTheLoginScreenButton(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff330066)),
          onPressed: () => goToTheLoginScreenButton(context),
          child: const Text('Вернуть ко входу', style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}