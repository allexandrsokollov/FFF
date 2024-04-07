import 'package:app_planning_budget/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'RegistrarionScreen.dart';
import 'LoginScreen.dart';

class OpeningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
        child:
            Column(
              children: [
                const Image(image: AssetImage('assets/OpeningImage.jpg')),
                const SizedBox(height: 25),
                const Text('Добро пожаловать!', style: TextStyle(fontSize: 25),),
                const Text('Теперь все ваши финансы в одном месте', style: TextStyle(fontSize: 18, color: Colors.black45)),
                const Text('и всегда под контролем', style: TextStyle(fontSize: 18, color: Colors.black45)),
                const SizedBox(height: 25),
                LogButtons(onPressed: () => goToTheLogin(context), text: 'Войти', isRegistration: false,),
                LogButtons(onPressed: () => goToTheRegistration(context), text: 'Создать аккаунт', isRegistration: true),
              ]
            )
        );
  }
}

void goToTheRegistration(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
}

void goToTheLogin(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

class LogButtons extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final bool isRegistration;

  LogButtons({
    required this.onPressed,
    required this.text,
    required this.isRegistration
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
        height: 60, 
        child: Container( 
          margin: const EdgeInsets.all(8),
          child: OutlinedButton(
          style: isRegistration ? ElevatedButton.styleFrom(foregroundColor: Colors.black,
              textStyle: const TextStyle(fontSize: 18),
              side: const BorderSide(width: 1.0, color: Colors.black)) : ElevatedButton.styleFrom(foregroundColor: Colors.white,
              backgroundColor: Color(0xff330066),
              textStyle: const TextStyle(fontSize: 18),
              side: const BorderSide(width: 1.0, color: Color(0xff330066))),
        onPressed: onPressed,
        child: Text(text)
    ),
        )
    );
  }
}

