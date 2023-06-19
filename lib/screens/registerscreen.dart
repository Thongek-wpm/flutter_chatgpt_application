// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  Profile profile = Profile(
    fullname: '',
    email: '',
    password: '',
    birthdate: '',
    confirmPassword: '',
    imageUrl: '',
  );
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  List<String> partners = [];

  void addPartner(String partnerName) {
    if (!partners.contains(partnerName)) {
      partners.add(partnerName);
    }
  }

  bool isPartner(String partnerName) {
    return partners.contains(partnerName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String fullName = _firstNameController.text;
        String email = _emailController.text;
        String password = _passwordController.text;
        String birthdate = _birthdateController.text;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (_image != null) {
          String imageUrl = await uploadImageToFirebaseStorage(_image!);

          DocumentReference userDocRef = FirebaseFirestore.instance
              .collection('profiles')
              .doc(userCredential.user!.uid);

          await userDocRef.set({
            'full_name': fullName,
            'email': email,
            'birthdate': birthdate,
            'imageUrl': imageUrl,
          });
        } else {
          // Handle case when no image is selected
        }

        // Redirect to another screen or perform additional actions
      } catch (e) {
        // Handle registration failure here
      }
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference = _storage.ref().child('images/$fileName');

    final UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;

    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> saveUserProfile(String imageUrl) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final String userId = user.uid;

      await _firestore.collection('users').doc(userId).set({
        'name': _nameController.text,
        'imageUrl': imageUrl,
      });
    }
  }

  CollectionReference profilesCollection =
      FirebaseFirestore.instance.collection('profiles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).hintColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Image'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: const Text('Gallery'),
                                onTap: () async {
                                  PickedFile? pickedFile = await picker
                                      .getImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    setState(() {
                                      _image = File(pickedFile.path);
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                child: const Text('Camera'),
                                onTap: () async {
                                  PickedFile? pickedFile = await picker
                                      .getImage(source: ImageSource.camera);
                                  if (pickedFile != null) {
                                    setState(() {
                                      _image = File(pickedFile.path);
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Full name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.fullname = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.email = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.password = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password.';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.confirmPassword = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                // ignore: prefer_const_constructors
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                controller: _birthdateController,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      _birthdateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Birthdate',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          _birthdateController.text =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      });
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your birthdate.';
                  }
                  return null;
                },
                onSaved: (value) {
                  profile.birthdate = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        try {
                          String fullName = _firstNameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          String birthdate = _birthdateController.text;

                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          String imageUrl = '';
                          if (_image != null) {
                            imageUrl =
                                await uploadImageToFirebaseStorage(_image!);
                          }

                          DocumentReference userDocRef = FirebaseFirestore
                              .instance
                              .collection('profiles')
                              .doc(userCredential.user!.uid);

                          await userDocRef.set({
                            'full_name': fullName,
                            'email': email,
                            'birthdate': birthdate,
                            'imageUrl': imageUrl,
                          });

                          _formKey.currentState!.reset();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Registration Successful'),
                                content: const Text(
                                    'Your registration was successful.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Registration Failed'),
                                content: const Text(
                                    'An error occurred during registration.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.person_add_rounded,
                          size: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        setState(() {
                          _image = null;
                          _firstNameController.text = '';
                          _emailController.text = '';
                          _passwordController.text = '';
                          _confirmPasswordController.text = '';
                          _birthdateController.text = '';
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.cleaning_services_outlined,
                            size: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Clean'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
