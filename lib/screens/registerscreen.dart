import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  List<String> partners = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
    _birthdateController.dispose();
    super.dispose();
  }

  void registerUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        String fullName = _firstNameController.text;
        String birthdate = _birthdateController.text;

        // Upload user image to Firebase Storage
        if (_image != null) {
          Reference ref = _storage.ref().child('profile_images/${user.uid}');
          await ref.putFile(_image!);
          String imageUrl = await ref.getDownloadURL();
          // Save image URL to user document in Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'fullName': fullName,
            'birthdate': birthdate,
            'imageUrl': imageUrl,
          });
        } else {
          // Save user information without image URL to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'fullName': fullName,
            'birthdate': birthdate,
          });
        }

        // Redirect to another screen or perform additional actions
      }
    } catch (e) {
      // Handle registration errors
      print('Error registering user: $e');
    }
  }

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
                onTap: () {
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
                                onTap: () {
                                  Navigator.of(context).pop();
                                  getImage(ImageSource.gallery);
                                },
                              ),
                              const SizedBox(height: 16.0),
                              GestureDetector(
                                child: const Text('Camera'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  takePicture();
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
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? const Icon(Icons.add_a_photo) : null,
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 16.0),
              // Rest of the form fields...
              // ...
              // ...

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform registration logic here
                    registerUser();
                  }
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _firstNameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                      _birthdateController.clear();
                      setState(() {
                        _image = null;
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.cleaning_services_sharp,
                          size: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            
          ),
        ),
    
    );
  }
}
