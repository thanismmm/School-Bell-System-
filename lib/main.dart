import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_bell_system/page/sheduleupdate.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAXk_LxdXeYojxUpvhCKk1n4QftfMXLcoM",
      appId: "1:734412678205:android:d47279e9ac816ae22ef654",
      messagingSenderId: "734412678205",
      projectId: "bell-system-621ae",
      storageBucket: "sbell-system-621ae.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ScheduleUpdate());
  }
}
