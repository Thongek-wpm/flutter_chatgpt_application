// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/screens/chatscreen.dart';
import 'package:flutter_chatgpt_application/screens/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Profile profile = Profile(
    fullname: '',
    email: '',
    password: '',
    birthdate: '',
    confirmPassword: '',
    imageUrl: '',
  );
  Future saveLoginTypeToSP(String profile) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var collection = FirebaseFirestore.instance.collection('profiles');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var email = data['email']; // <-- Retrieving the value.
      if (email == email) {
        String docId = doc.id;
        sp.setString('Id', docId);
        sp.setString('email', email);
        sp.setString('fullName', data['fullName']);
        sp.setString('password', data['password']);
        sp.setString('birthdate', data['birthdate']);
        sp.setString('confirmPassword', data['confirmPassword']);
        sp.setString('imageUrl', data['imageUrl']);
      }
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your E-mail';
                        } else if (!isValidEmail(value)) {
                          return 'Please enter a valid E-mail';
                        }
                        return null;
                      },
                      onSaved: (String? email) {
                        profile.email = email!;
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
                      onSaved: (String? password) {
                        profile.password = password!;
                      },
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                            try {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: profile.email,
                                password: profile.password,
                              )
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Welcome to ChatGPT"),
                                    behavior: SnackBarBehavior.fixed,
                                  ),
                                );
                                _formKey.currentState!.reset();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ChatScreen();
                                    },
                                  ),
                                );
                              });
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message!),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              _formKey.currentState!.reset();
                            }
                          },
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
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
                            builder: (context) => const RegisterScreen(),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
