import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double height;
  final double width;
  const Logo(this.height, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/logo.jpeg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(400)),
    );
  }
}
