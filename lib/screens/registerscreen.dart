import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthdateController.dispose();
    super.dispose();
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
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value != _confirmPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    if (_passwordController.text != value) {
                      setState(() {
                        _formKey.currentState!.validate();
                      });
                    }
                  },
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      _birthdateController.text =
                          selectedDate.toString().split(' ')[0];
                    });
                  }
                },
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: 'Birthdate',
                  filled: true,
                  fillColor: Colors.grey[200],
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          _birthdateController.text =
                              selectedDate.toString().split(' ')[0];
                        });
                      }
                    },
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform registration logic here
                          String firstName = _firstNameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          String birthdate = _birthdateController.text;

                          // Add your registration code here

                          // Reset form fields
                          _firstNameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          _birthdateController.clear();
                          _confirmPasswordController.clear();
                          _image = null;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Registration Successful'),
                              content: const Text(
                                  'You have successfully registered.'),
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
                        }
                      },
                      child: const Text('Register'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(30.0, 30.0)),
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
                            _firstNameController.clear();
                            _emailController.clear();
                            _passwordController.clear();
                            _birthdateController.clear();
                            _confirmPasswordController.clear();
                            _image = null;
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
