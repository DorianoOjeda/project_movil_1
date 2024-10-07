import 'package:flutter/material.dart';
import 'package:project_1/ui/pages/auth/signup.dart';
import 'package:project_1/ui/pages/init_page.dart';
import 'ui/pages/auth/login.dart';
import 'ui/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Mi Mejor Ser",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/initialPage",
        routes: {
          '/initialPage': (context) => const InitPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/home': (context) => const HomePage(),
        });
  }
}
