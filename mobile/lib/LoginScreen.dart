import 'package:app_planning_budget/Pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'PasswordRecoveryScreen.dart';

import 'RegistrarionScreen.dart';


String correctPassword = "";
final TextEditingController passwordController = TextEditingController();

bool checkPassword(String password) {
  return correctPassword == password;
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios))
            ),
            const SizedBox(height: 10),
            const Text('Войдите',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff330066))),
            const SizedBox(height: 30),
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child:  Text('Почта'),
              )
            ),
            LoginField(text: 'Адрес электронной почты'),
            const SizedBox(height: 15),
            const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child:  Text('Пароль'),
                )
            ),
            const PasswordField(text: "Пароль"),
            const SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child:  TextButton(onPressed: () => goToThePasswordRecovery(context), child: const Text("Забыли пароль?", style: TextStyle(color: Colors.black),))
                )
            ),
          ],
        )
      ),
      bottomNavigationBar: LoginButton(),
    );
  }
}

void goToTheRegistration(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
}

void goToThePasswordRecovery(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()));
}


class LoginField extends StatelessWidget {
  final String text;

  LoginField({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(7),
        child: TextField(
            style: const TextStyle(
                fontSize: 18, color: Colors.black, height: 0.001),
            decoration: InputDecoration(
                hintText: text,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ))));
  }
}

class PasswordField extends StatefulWidget {
  final String text;

  const PasswordField({super.key, required this.text, passwordVisible=true});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordVisible=false;

  @override
  void initState(){
    super.initState();
    passwordVisible=true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(7),
        child: TextField(
            style: const TextStyle(fontSize: 18, color: Colors.black, height: 0.001),
            obscureText: passwordVisible,
            controller: passwordController,
            decoration: InputDecoration(
                hintText: widget.text,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                          () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )
            )
        )
    );
  }
}

void goToTheMainScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Pages()));
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff330066)),
          onPressed: () {
            if (checkPassword(passwordController.text)) {
              goToTheMainScreen(context);
            }
          },
          child: const Text('Войти', style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}


