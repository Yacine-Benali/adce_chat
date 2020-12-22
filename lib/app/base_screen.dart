import 'package:adce_chat/app/conversations/conversations_screen.dart';
import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/app/profile/profile_screen.dart';
import 'package:adce_chat/services/api_path.dart';
import 'package:adce_chat/services/database.dart';
import 'package:adce_chat/services/firestore_service.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen._({Key key, this.database, this.uid}) : super(key: key);
  final Database database;
  final String uid;

  static Widget create({@required String uid}) {
    Database database = FirestoreService();
    return BaseScreen._(
      database: database,
      uid: uid,
    );
  }

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Database get database => widget.database;
  Stream<ChatUser> userStream;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    userStream = database.documentStream(
      path: APIPath.userDocument(widget.uid),
      builder: (data, documentId) => ChatUser.fromMap(data, documentId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatUser>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ConversationsScreen.create(
            context: context,
            user: snapshot.data,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 32.0, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Can\'t load items right now',
                    style: TextStyle(fontSize: 16.0, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data == null) {
          return ProfileScreen.create(
            context: context,
            user: null,
            uid: widget.uid,
            database: database,
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
