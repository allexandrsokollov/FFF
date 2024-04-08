import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'EnterEmailCodeScreen.dart';

var email;

class PasswordRecoveryScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(onPressed: () {
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back_ios))
                ),
                const SizedBox(height: 25),
                const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Забыли пароль?', style: TextStyle(fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff330066))),
                          Text('Введите адрес электронной почты, cвязанный'),
                          Text('с Вашим аккаунтом.'),
                          SizedBox(height: 25),
                          Text("Почта", style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                ),
                Container(
                  margin: const EdgeInsets.all(7),
                  child: TextField(
                    onChanged: (value) {email = value;},
                    controller: emailController,
                    style: const TextStyle(
                    fontSize: 18, color: Colors.black, height: 0.001),
                    decoration: InputDecoration(
                    hintText: "Адрес электронной почты",
                    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    counterText: "",
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )))),
                SizedBox(height: 25),
                SendCodeButton()
              ],
            )
        ),
    );
  }
}

void goToTheEnterEmailCode(BuildContext context) {
  if (email != null) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EnterEmailCodeScreen(email)));
  }
}

class SendCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff330066)),
          onPressed: () => goToTheEnterEmailCode(context),
          child: const Text('Отправить код', style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}