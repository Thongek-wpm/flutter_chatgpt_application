import 'package:firebase_auth/firebase_auth.dart';

// ...

void signInWithEmailAndPassword() {
  FirebaseAuth auth = FirebaseAuth.instance;

  auth
      .signInWithEmailAndPassword(
    email: 'user@example.com',
    password: 'password',
  )
      .then((result) {
    // ดำเนินการหลังจากการเข้าสู่ระบบสำเร็จ
  }).catchError((error) {
    // ดำเนินการหลังจากเกิดข้อผิดพลาดในการเข้าสู่ระบบ
  });
}

// ...
