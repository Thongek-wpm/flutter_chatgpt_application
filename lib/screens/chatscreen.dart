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

  String? imageUrl;
  String? fullname;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
    // อื่น ๆ ที่คุณต้องการทำในการทำลายวัตถุ
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? email = sp.getString('email');

    QuerySnapshot querySnapshot = await firestore
        .collection('profiles')
        .where('email', isEqualTo: email)
        .limit(3)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      Object? data = doc.data();
      String imageUrl = (data! as Map<String, dynamic>)['imageUrl'] as String;
      fullname = (data as Map<String, dynamic>)['fullname'] as String?;

      if (mounted) {
        setState(() {
          this.imageUrl = imageUrl;
          profile.fullname = fullname ?? '';
        });
      }
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
                  image: NetworkImage(
                    'https://images.pexels.com/photos/531880/pexels-photo-531880.jpeg?cs=srgb&dl=pexels-pixabay-531880.jpg&fm=jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: imageUrl != null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(imageUrl!),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/default_profile.png'),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    profile.fullname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
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
