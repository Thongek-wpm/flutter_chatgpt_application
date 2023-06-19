import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:flutter_chatgpt_application/screens/chatscreen.dart';
import 'package:flutter_chatgpt_application/screens/dashboardscreen.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';

class ProFileSrceen extends StatefulWidget {
  const ProFileSrceen({super.key});

  @override
  State<ProFileSrceen> createState() => _ProFileSrceenState();
}

class _ProFileSrceenState extends State<ProFileSrceen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(profile.fullname),
                ],
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
                                return LoginScreen();
                              },
                            ),
                          ),
                        },
                      );
                },
                child: Text('LOGOUT'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
