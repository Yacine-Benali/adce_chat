import 'package:adce_chat/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String title;
  bool isLoading = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    final auth = FirebaseAuthService();
    try {
      await auth.signInWithGoogle();
    } on Exception catch (e) {
      print(e);
    }
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Welcome to ADCE Chat',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget buildSpinner(BuildContext context) {
    final ThemeData data = Theme.of(context);
    return Theme(
      data: data.copyWith(accentColor: Colors.white70),
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: Text('Sign in'),
      ),
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 70.0),
            SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
            SizedBox(height: 80.0),
            SizedBox(
              height: 50,
              child: RaisedButton(
                child: isLoading
                    ? buildSpinner(context)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset('assets/go-logo.png'),
                          Text(
                            'Login in with google',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Opacity(
                            opacity: 0.0,
                            child: Image.asset('assets/go-logo.png'),
                          ),
                        ],
                      ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      4.0,
                    ),
                  ),
                ), // height / 2
                color: Colors.white,
                disabledColor: Colors.white,
                //textColor: textColor,
                onPressed: isLoading ? null : () => _signInWithGoogle(context),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
