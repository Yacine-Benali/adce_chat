import 'package:adce_chat/app/landing_screen.dart';
import 'package:adce_chat/services/auth.dart';
import 'package:adce_chat/services/firebase_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Better School',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Provider<Auth>(
        create: (_) => FirebaseAuthService(),
        child: LandingScreen(),
      ),
    );
  }
}
