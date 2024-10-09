import 'package:ecs_app/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
import 'firebase_options.dart'; // Optional if using Firebase CLI setup

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that binding is initialized before running app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Optional if using Firebase CLI setup
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
