import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/models/profiles.dart';
import 'package:flutter_chatgpt_application/screens/chatscreen.dart';
import 'package:flutter_chatgpt_application/screens/dashboardscreen.dart';
import 'package:flutter_chatgpt_application/screens/editprofilescreen.dart';
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
              leading: const Icon(
                Icons.chat,
                color: Colors.white,
              ),
              title: const Text(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
              leading: const Icon(
                Icons.filter_1_sharp,
                color: Colors.white,
              ),
              title: const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
              leading: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 10),
                child: Text(
                  'Profiles',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 150,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    // Handle menu 1 tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.mode_edit_outline,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Edit Profiles',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          profile.imageUrl.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.network(
                      profile.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
          Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Name : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      profile.fullname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'E-mail : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      auth.currentUser!.email!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'PassWord : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.mode_edit,
                              size: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'EditPassword',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'BirthDate : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      profile.birthdate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).highlightColor,
    );
  }
}
