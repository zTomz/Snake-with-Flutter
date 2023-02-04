import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/pages/game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Snake',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD5DCF9),
        ),
        scaffoldBackgroundColor: const Color(0xFF0C101D),
      ),
      home: const GamePage(),
    );
  }
}
