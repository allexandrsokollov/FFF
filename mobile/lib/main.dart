import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'OpeningScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainPages());
}

// Возможно, здесь потом будет проверка на авторизованного пользователя и в зависимости
// от этого будет открываться начальный экран либо регистрация, либо уже стартовая страница
class MainPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('ru')
      ],
      home: OpeningScreen()
    );
  }
}



