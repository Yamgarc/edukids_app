import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduKids App',
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja de debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // O la fuente que use tu entorno
      ),
      home: const LoginScreen(), // Establece la pantalla inicial
    );
  }
}