import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions (
    apiKey: "AIzaSyDPzwY80-oZCo5bYoaHAoA0x-3vwaLU7dA",
    authDomain: "moviewatcher-app-9388f.firebaseapp.com",
    projectId: "moviewatcher-app-9388f",
    storageBucket: "moviewatcher-app-9388f.firebasestorage.app",
    messagingSenderId: "168780394464",
    appId: "1:168780394464:web:acc8cac29f4277d3b24585",
    measurementId: "G-ZV8PDPCR6L"
      ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Watcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
