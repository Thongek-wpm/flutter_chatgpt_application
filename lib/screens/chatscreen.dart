import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/models/chat_messener.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:flutter_chatgpt_application/screens/chatmessenerwidget.dart';
import 'package:flutter_chatgpt_application/screens/dashboardscreen.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';
import 'package:flutter_chatgpt_application/screens/profilescreen.dart';
import 'package:http/http.dart' as https;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
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
    isLoading = false;
  }

  final auth = FirebaseAuth.instance;
  //firebaseAuth login
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // ignore: prefer_typing_uninitialized_variables
  var results;

  Future<String> generateResponse(String prompt) async {
    const apiKey = "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";
    var url = Uri.https("api.openai.com", "/v1/completions");
    final respnse = await https.post(
      url,
      headers: {
        "content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: json.encoder,
    );
    Map<String, dynamic> newresonse = jsonDecode(respnse.body);
    return newresonse['choices'][0]['text'];
  }

  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessener> _messages = [];
  late bool isLoading;

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(microseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
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
                    return CircularProgressIndicator();
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
                              return CircularProgressIndicator();
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
                                return Text('Profile not found');
                              }
                            }
                          },
                        );
                      } else {
                        return Text('User not found');
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
      body: Expanded(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, Index) {
              var messages = _messages[Index];
              return ChatMessenerWidget(
                text: messages.text,
                chatMessageType:messages.chatMessageType ,
              );
            }),
      ),
    );
  }
}
