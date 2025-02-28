import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/player_screen.dart';
import 'screens/upload_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug label
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/player': (context) => const PlayerScreen(),
        '/upload': (context) => const UploadScreen(),
      },
    );
  }
}
