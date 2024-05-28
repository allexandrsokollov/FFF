import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'LoginScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://avatars.mds.yandex.net/i?id=26d5d27e3273d3d09a4ddbcba6865c97ec572dc0-11499518-images-thumbs&n=13'),
                ),
              ),
              const Text('Иванов Петр', style: TextStyle(fontSize: 16)),
              const Text('helloworld@gmail.com', style: TextStyle(fontSize: 16)),
              Spacer(),
              Container(
                height: 450,
                  decoration: BoxDecoration(
                      color: Color(0xffdbe6fb),
                      border: Border.all(width: 2, color: Color(0xffdbe6fb)),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff330066)),
                            child: const Text('Редактировать', style: TextStyle(color: Colors.white))
                        ),
                      ),
                      SizedBox(height: 10),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text("Имя"),
                      ),
                      InfoField(text: "Имя пользователя"),
                      SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text("Почта"),
                      ),
                      InfoField(text: "helloworld@gmail.com"),
                      SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text("Пароль"),
                      ),
                      const PasswordField(text: "Пароль"),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff330066)),
                            child: const Text('Сохранить', style: TextStyle(color: Colors.white))
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () => goToTheLoginScreen(context),
                            child: const Text('Выйти',
                                style: TextStyle(color: Colors.red,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17)))
                      )
                    ],
                  )
              ),],
          ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String text;

  InfoField({required this.text});

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

void goToTheLoginScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
}



