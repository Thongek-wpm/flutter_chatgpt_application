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
  late String fullname = fullname; // เพิ่มการกำหนดค่าเริ่มต้นให้กับ fullname
  @override
  void initState() {
    super.initState();
    fetchUserProfile().then((_) {
      setState(() {
        fullname = profile.fullname;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // อื่น ๆ ที่คุณต้องการทำในการทำลายวัตถุ
  }

  Future<void> saveLoginTypeToSP(String email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var collection = FirebaseFirestore.instance.collection('profiles');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var docEmail = data['email'];
      if (docEmail == email) {
        String docId = doc.id;
        sp.setString('Id', docId);
        sp.setString('email', email);
        sp.setString('fullName', data['fullName']);
        sp.setString('password', data['password']);
        sp.setString('birthdate', data['birthdate']);
        sp.setString('confirmPassword', data['confirmPassword']);
        break;
      }
    }
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? email = sp.getString('email');

    QuerySnapshot querySnapshot = await firestore
        .collection('profiles')
        .where('email', isEqualTo: email)
        .limit(2)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String imageUrl = data['imageUrl'] as String;
      String? fullname = data['fullname'] as String?;

      setState(() {
        this.imageUrl = imageUrl;
        profile.fullname = fullname ?? '';
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
                (_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          if (imageUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
            ),
          const SizedBox(height: 10),
          Text(profile.fullname),
        ],
      ),
    );
  }
}
