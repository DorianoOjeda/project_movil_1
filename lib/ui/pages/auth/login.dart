import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_1/managers/handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF12005E)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 100.0,
                      bottom: 20.0,
                    ),
                    child: Center(
                      child: getLogo(150, 150),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Mi Mejor Ser",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: mailController,
                      style: const TextStyle(color: Colors.white),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your email address'),
                        EmailValidator(
                            errorText: 'Please enter a valid email address'),
                      ]).call,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Email',
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Please enter a password'),
                        MinLengthValidator(8,
                            errorText:
                                'Password must be at least 8 characters long'),
                        PatternValidator(r'(?=.*?[#_?!@$%^&*-])',
                            errorText:
                                'Passwords must have at least one special character'),
                      ]).call,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Password',
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 112, 2, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Let\'s Go',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await getAuthRemote().signIn(
                                mailController.text, passwordController.text);
                            Navigator.pushNamed(
                              context,
                              '/navigation',
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
