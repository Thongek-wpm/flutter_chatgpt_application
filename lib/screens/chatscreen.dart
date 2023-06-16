import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  String? imageUrl; // เปลี่ยนเป็น nullable ให้ imageUrl สามารถเป็น null ได้

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // เรียกใช้เมธอด fetchUserProfile เพื่อดึงข้อมูลโปรไฟล์ผู้ใช้
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? email = sp.getString('email');

    QuerySnapshot querySnapshot = await firestore
        .collection('profiles')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      Object? data = doc.data();
      String imageUrl = (data! as Map<String, dynamic>)['imageUrl'] as String;
      setState(() {
        this.imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatGPT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
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
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/background-blue.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ClipRRect(
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/default_profile.png', // รูปภาพเริ่มต้นใน assets
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
