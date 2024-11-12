import 'package:flutter/material.dart';
import 'package:project_1/firebase_options.dart';
import 'package:project_1/managers/handler.dart';
import 'package:project_1/ui/pages/auth/signup.dart';
import 'package:project_1/ui/pages/init_page.dart';
import 'package:project_1/ui/pages/navbar.dart';
import 'package:project_1/ui/pages/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => getTaskController()),
    ChangeNotifierProvider(create: (_) => getRachasController()),
  ], child: const MyApp()));
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
          '/navigation': (context) => const NavBar(),
        });
  }
}
