import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_1/managers/handler.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
        child: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height - 50, // Ajusta la altura
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
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
                        style: const TextStyle(color: Colors.white),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please enter your first name'),
                          MinLengthValidator(3,
                              errorText:
                                  'First name must be at least 3 characters long'),
                        ]).call,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter first name',
                          labelText: 'First name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          errorStyle: TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please enter your last name'),
                          MinLengthValidator(3,
                              errorText:
                                  'Last name must be at least 3 characters long'),
                        ]).call,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter last name',
                            labelText: 'Last name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
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
                              //Color.fromARGB(255, 112, 2, 255),
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Please enter a password'),
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
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              getAuthRemote().signUp(
                                mailController.text,
                                passwordController.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User registered successfully'),
                                ),
                              );
                              Navigator.pushNamed(
                                context,
                                '/initialPage',
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
