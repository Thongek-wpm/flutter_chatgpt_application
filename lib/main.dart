import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.grey.shade900,
              hintColor: Colors.grey.shade600,
              textTheme: const TextTheme(
                  // กำหนดสีตัวอักษรทั้งหมดในแอปเป็นสีขาว

                  // เพิ่มสไตล์ข้อความอื่น ๆ ที่ต้องการใช้งาน
                  ),
              buttonTheme: ButtonThemeData(
                buttonColor:
                    Colors.greenAccent.shade700, // สีที่ต้องการจากเว็บ ChatGPT
                textTheme: ButtonTextTheme.primary,
                // สีของปุ่ม
              ),
              // เพิ่มสีอื่น ๆ ที่ต้องการใช้งาน
            ),
            home: const LoginScreen(),
          );
        }
      },
    );
  }
}
