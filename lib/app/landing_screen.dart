import 'package:adce_chat/app/base_screen.dart';
import 'package:adce_chat/app/sign_in/sign_in_screen.dart';
import 'package:adce_chat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return StreamBuilder<AuthUser>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          AuthUser user = snapshot.data;
          if (user == null) {
            return SignInScreen();
          } else {
            return Provider<AuthUser>.value(
              value: user,
              child: BaseScreen.create(uid: user.uid),
            );
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
