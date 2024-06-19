import 'package:flutter/material.dart';
import 'OpeningScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

AppMetricaConfig get _config => const AppMetricaConfig('c99878bb-5390-4f8e-8ad0-82b9b97cd60c', logs: true);

void main() {
  AppMetrica.activate(_config);
  runApp(MainPages());
}

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



