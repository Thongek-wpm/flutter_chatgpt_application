// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/screens/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // ดำเนินการเมื่อปุ่ม Login ถูกกด
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50.0,
              ),
              child: Image.asset(
                'assets/images/chat_gpt.png',
                width: 80.0,
                height: 80.0,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Welcome to ChatGPT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 16),
                        filled: true,
                        hintText: 'Enter your E-mail',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your E-mail';
                        } else if (!isValidEmail(value)) {
                          return 'Please enter a valid E-mail';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: TextFormField(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 16),
                        filled: true,
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(30.0, 30.0)),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.greenAccent.shade700,
                          ),
                        ),
                        onPressed: _login,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.login,
                              size: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Login'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(30.0, 30.0)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.cleaning_services,
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Clean'),
                              ),
                            ],
                          ),
                          onPressed: () {
                            // ดำเนินการเมื่อปุ่ม Clean ถูกกด
                            setState(() {
                              // ลบข้อมูลในฟอร์ม
                              _formKey.currentState!.reset();
                            });
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clean Pressed'),
                                content:
                                    const Text('Form data has been cleared.'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'If you don\'t have an account yet:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to RegisterScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Or sign in with:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200.0, 40.0)),
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('sign in with Google'),
              onPressed: () {
                // ดำเนินการเมื่อปุ่ม Google ถูกกด
              },
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200.0, 40.0)),
                backgroundColor: MaterialStateProperty.all(
                  Colors.blue.shade800,
                ),
              ),
              child: const Text('sign in with Facebook'),
              onPressed: () {
                // ดำเนินการเมื่อปุ่ม Facebook ถูกกด
              },
            ),
          ],
        ),
      ),
    );
  }
}
