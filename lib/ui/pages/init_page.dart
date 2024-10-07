import 'package:flutter/material.dart';
import '../../handler.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF12005E)], // Fondo degradado
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getLogo(300, 300),
              const Text(
                "Mi Mejor Ser",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              getNavigationButton('/login', "Login"),
              const SizedBox(height: 20),
              getNavigationButton('/signup', "Sign Up"),
            ],
          ),
        ),
      ),
    );
  }
}
