import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_application/screens/loginscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        hintColor: Colors.grey.shade600,
        textTheme: const TextTheme(
          // กำหนดสีตัวอักษรทั้งหมดในแอปเป็นสีขาว
          bodyLarge: TextStyle(color: Colors.white),
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
}
