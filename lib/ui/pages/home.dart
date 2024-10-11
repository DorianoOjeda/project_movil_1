import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: 50.0, bottom: 30.0, left: 30.0, right: 30.0),
      child: const Text("Bienvenido a Mi Mejor Ser",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
