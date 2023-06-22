// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, empty_catches

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:flutter_chatgpt_application/screens/dashboardscreen.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';
import 'package:flutter_chatgpt_application/screens/profilescreen.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Profile profile = Profile(
    fullname: '',
    email: '',
    password: '',
    birthdate: '',
    confirmPassword: '',
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();
  }

  final auth = FirebaseAuth.instance;
  //firebaseAuth login
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // ignore: prefer_typing_uninitialized_variables
  var results;

  Future<String> fetchChatbotResponse(String message) async {
    String apiUrl = 'https://api.openai.com/v1/chat/completions';
    String apiKey = 'YOU_KEY_API';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var body = {
      'prompt': message,
      'max_tokens': 50,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var completion = data['choices'][0]['text'];
      return completion;
    } else {
      throw Exception('Failed to fetch chatbot response');
    }
  }

  List<String> chatMessages = [];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) async {
    setState(() {
      chatMessages.add('You: $message');
    });

    // Send the message to the chatbot API
    String response = await fetchChatbotResponse(message);

    setState(() {
      chatMessages.add('Bot: $response');
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
        backgroundColor: Theme.of(context).primaryColor, // กำหนดสีของ AppBar
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).highlightColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/08/30/01/05/milky-way-2695569_1280.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: FutureBuilder(
                future:
                    firebase, // Future ของ FirebaseApp จากการเรียก Firebase.initializeApp()
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // ดึง user ที่เข้าสู่ระบบ
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // ดึงข้อมูลจาก Firestore
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('profiles')
                              .doc(user.uid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                // แปลงข้อมูลจาก Firestore เป็นคลาส Profile
                                final data = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                final profile = Profile(
                                  fullname: data['fullname'] ?? '',
                                  email: data['email'] ?? '',
                                  password: data['password'] ?? '',
                                  birthdate: data['birthdate'] ?? '',
                                  confirmPassword:
                                      data['confirmPassword'] ?? '',
                                  imageUrl: data['imageUrl'] ?? '',
                                );

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(profile.fullname),
                                  ],
                                );
                              } else {
                                return const Text('Profile not found');
                              }
                            }
                          },
                        );
                      } else {
                        return const Text('User not found');
                      }
                    }
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                // Handle menu 1 tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_1_sharp),
              title: const Text('Dashboard'),
              onTap: () {
                // Handle menu 1 tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashBardScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Handle menu 1 tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProFileSrceen(),
                  ),
                );
              },
            ),
            // Add other menu items as needed
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  auth.signOut().then(
                        (value) => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginScreen();
                              },
                            ),
                          ),
                        },
                      );
                },
                child: const Text('LOGOUT'),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(chatMessages[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: 'Enter your message...',
                        filled: true, // เปิดใช้งานพื้นหลังของ TextField
                        fillColor: Colors
                            .transparent, // กำหนดสีพื้นหลังเป็นโปร่งแสงหรือไม่มีสี
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.green.shade400,
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).highlightColor,
    );
  }
}
