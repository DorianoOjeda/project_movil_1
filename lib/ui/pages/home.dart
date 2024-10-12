import 'package:flutter/material.dart';
import 'package:project_1/handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 95, 50, 150),
              Color.fromARGB(255, 54, 29, 163)
            ], // Fondo degradado
          ),
        ),
        padding: const EdgeInsets.only(
            top: 100.0, bottom: 30.0, left: 30.0, right: 30.0),
        child: Center(
          child: Column(
            children: [
              const Text("Hola [username]!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 80.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        child: Image(image: AssetImage(getRachaImagePath())),
                      ),
                    ),
                    const Text(
                      "0",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("¿Qué deseas hacer hoy?",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 20),
              const Text("Implementar [agregar tareas]",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ));
  }
}
