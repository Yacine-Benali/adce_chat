import 'package:adce_chat/app/base_screen.dart';
import 'package:adce_chat/app/sign_in/sign_in_screen.dart';
import 'package:adce_chat/services/auth.dart';
import 'package:adce_chat/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          AuthUser user = snapshot.data;
          if (user == null) {
            return SignInScreen();
          } else {
            return BaseScreen.create(uid: user.uid);
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
