import 'dart:io';
import 'dart:core';
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
  List<String> partners = [];

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
                    helperText:
                        '*Please enter your full name: Firstname_Lastname*',
                    helperStyle:
                        const TextStyle(color: Colors.white54, fontSize: 12.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name';
                    }

                    // Validate if the name follows the format: Firstname_Lastname
                    RegExp nameRegex = RegExp(r'^[A-Za-z]+_[A-Za-z]+$');
                    if (!nameRegex.hasMatch(value)) {
                      return 'Please enter your full name : Firstname_Lastname';
                    }

                    return null;
                  },
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
                    helperText: 'Please enter a valid email address',
                    helperStyle:
                        const TextStyle(color: Colors.white54, fontSize: 12.0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }

                    // Validate if the email is in the correct format
                    RegExp emailRegex =
                        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
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
                    helperText:
                        '*Password must contain at least 8 characters.*',
                    helperStyle:
                        const TextStyle(color: Colors.white54, fontSize: 12.0),
                  ),
                  validator: (value) {
                    if (value!.length < 8) {
                      return 'Password must contain at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
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
                    helperText: '*Confirm Password must do match.*',
                    helperStyle:
                        const TextStyle(color: Colors.white54, fontSize: 12.0),
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
                    lastDate: DateTime(DateTime.now().year + 1),
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
                        lastDate: DateTime(DateTime.now().year + 1),
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your birthdate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform registration logic here
                        String fullName = _firstNameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String birthdate = _birthdateController.text;

                        // Register user with the provided information

                        // Redirect to another screen or perform additional actions
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
                  const SizedBox(width: 16.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
