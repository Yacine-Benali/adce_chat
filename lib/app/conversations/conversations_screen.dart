import 'package:adce_chat/app/chat/chat_screen.dart';
import 'package:adce_chat/app/conversations/conversation_tile.dart';
import 'package:adce_chat/app/conversations/conversations_bloc.dart';
import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/app/profile/profile_screen.dart';
import 'package:adce_chat/services/auth.dart';
import 'package:adce_chat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationsScreen extends StatefulWidget {
  final ConversationsBloc bloc;

  const ConversationsScreen._({Key key, this.bloc}) : super(key: key);

  static Widget create({
    @required BuildContext context,
    @required ChatUser user,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    ConversationsBloc bloc = ConversationsBloc(database: database, user: user);
    return ConversationsScreen._(bloc: bloc);
  }

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  ConversationsBloc get bloc => widget.bloc;

  Stream conversationStream;
  @override
  void initState() {
    conversationStream = bloc.getUsers();
    super.initState();
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text("Do you want to logout ?"),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
    if (didRequestSignOut == true) {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Users')),
        leading: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: InkWell(
            onTap: () => Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen.create(
                  context: context,
                  uid: bloc.user.id,
                  user: bloc.user,
                  database: bloc.database,
                ),
                fullscreenDialog: true,
              ),
            ),
            child: Icon(
              Icons.account_circle,
              size: 26.0,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () => _confirmSignOut(context),
              child: Icon(
                Icons.exit_to_app,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Material(
        child: StreamBuilder<List<ChatUser>>(
          stream: conversationStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                final List<ChatUser> items = snapshot.data;
                if (items.isNotEmpty) {
                  return _buildList(items);
                } else {
                  return Container();
                }
              } else if (snapshot.hasError) {
                return Container();
              }
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildList(List<ChatUser> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }

        if (bloc.user.id != items[index - 1].id) {
          return UserTile(
            chatUser: items[index - 1],
            onTap: () async => await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen.create(
                  currentUser: bloc.user,
                  database: bloc.database,
                  otherUser: items[index - 1],
                ),
                fullscreenDialog: false,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
