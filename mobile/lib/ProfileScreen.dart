import 'dart:io';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'LoginScreen.dart';
import 'package:image_picker/image_picker.dart';

bool isTextFieldEnable = false;
String name = "Иванов Петр";
String email = "helloworld2002@gmail.com";
String password = "testadmin2007";
File? _image;

final FirebaseAnalytics analytics =  FirebaseAnalytics.instance;

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:Column(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: Color(0xff330066),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/Avatar.jpg'),
                  )
                ),
              ),
              Text(name, style: TextStyle(fontSize: 16)),
              Text(email, style: TextStyle(fontSize: 16)),
              SizedBox(height: 30),
              Container(
                height: 450,
                  decoration: BoxDecoration(
                      color: Color(0xffdbe6fb),
                      border: Border.all(width: 2, color: Color(0xffdbe6fb)),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child:
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isTextFieldEnable = !isTextFieldEnable;
                              });
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff330066)),
                            child: const Text('Редактировать', style: TextStyle(color: Colors.white))
                        ),
                      ),
                      SizedBox(height: 10),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text("Имя", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      InfoField(text: "Имя пользователя", textContorller: nameController),
                      SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text("Почта", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      InfoField(text: "helloworld@gmail.com", textContorller: emailController),
                      SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text("Пароль", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      PasswordField(text: "Пароль",textContorller: passwordController,),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (nameController.text.isNotEmpty) {
                                  name = nameController.text;
                                }

                                if (emailController.text.isNotEmpty) {
                                  email = emailController.text;
                                }

                                if (passwordController.text.isNotEmpty) {
                                  password = passwordController.text;
                                }
                              });
                            },
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
          )
    )
    );
  }
}


class InfoField extends StatelessWidget {
  TextEditingController textContorller;
  final String text;

  InfoField({required this.text, required this.textContorller});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(7),
        child: TextField(
          enabled: isTextFieldEnable,
            controller: textContorller,
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
  TextEditingController textContorller;
  bool isPasswordEnable = isTextFieldEnable;

  PasswordField({super.key, required this.text, passwordVisible=true, required this.textContorller});

  @override
  State<PasswordField> createState() => _PasswordFieldState(textContorller: textContorller);
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordVisible = false;
  TextEditingController textContorller;

  _PasswordFieldState({required this.textContorller});

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
          onTap: () async {
            await analytics.logEvent(
                name: 'pages_tracked',
              parameters: {
                  "page_name": "Profile"
              }
            );
          },
          controller: textContorller,
          enabled: widget.isPasswordEnable,
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
                    setState((){
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

// class Avatar extends StatefulWidget {
//
//   @override
//   _AvatarState createState() => _AvatarState();
// }
//
// class _AvatarState extends State<Avatar> {
//
//   Future<void> _getImage() async {
//
//
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path); // 将选定的图像文件赋给_image
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//           children: <Widget> [
//             GestureDetector(
//               onTap: _getImage,
//               child: CircleAvatar (
//                 radius: 50,
//                 backgroundImage: _image != null ? FileImage(_image!) : null,
//                 child: _image == null ? const Icon(Icons.camera_alt, size: 50, color: Colors.white) : null,
//               ),
//             )
//           ]
//         )
//     );
//   }
// }



