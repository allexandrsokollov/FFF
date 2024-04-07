import 'package:app_planning_budget/LoginScreen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child:Column(
            children: [
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios))
              ),
              const Image(image: AssetImage('assets/OpeningImage.jpg')),
              const SizedBox(height: 25),
              const Text('Создать аккаунт',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff330066))),
              const SizedBox(height: 10),
              RegistrationField(text: 'Имя пользователя'),
              RegistrationField(text: 'Электронная почта'),
              PasswordField(text: "Пароль"),
              PasswordField(text: 'Подтверждение пароля'),
              const SizedBox(height: 10),
              RegistrationButton()
          ],
        )
      ),
    );
  }
}

class RegistrationField extends StatelessWidget {
  final String text;

  RegistrationField({required this.text});

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

  const PasswordField({super.key, required this.text, passwordVisible=true });

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

class RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff330066)),
          onPressed: () {},
          child: const Text('Создать аккаунт', style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
