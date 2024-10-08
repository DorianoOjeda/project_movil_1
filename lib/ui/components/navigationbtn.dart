import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String buttonText;
  final String route;

  const NavigationButton(this.route, this.buttonText, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          route,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Botón redondeado
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 20,
        ),
      ),
    );
  }
}
