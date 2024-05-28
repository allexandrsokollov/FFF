import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter/material.dart';
import 'UpdatePasswordScreen.dart';

class EnterEmailCodeScreen extends StatelessWidget {
  var email;

  EnterEmailCodeScreen(String curEmail) {
    email = curEmail;
  }

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
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Проверьте свою',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff330066))),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('электронную почту',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff330066))),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Код отправлен на почту: ' + email,
                    style: const TextStyle(fontSize: 12, color: Color(0xff330066))),
              ),
              const SizedBox(height: 20),
              OtpTextField(
                numberOfFields: 4,
              ),
              const SizedBox(height: 10),
              CheckButton()
            ],
          )
      ),
    );
  }
}

void goToTheUpdatePasswordScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordScreen()));
}

class CheckButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff330066)),
          onPressed: () => goToTheUpdatePasswordScreen(context),
          child: const Text('Проверить', style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
