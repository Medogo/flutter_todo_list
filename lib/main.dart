import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thème principal
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Supprime la bannière de débogage
      home: HomeScreen(), // Définit l'écran principal comme `HomeScreen`
    );
  }
}
