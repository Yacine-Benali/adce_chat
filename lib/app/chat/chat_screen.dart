import 'package:adce_chat/app/chat/chat_bloc.dart';
import 'package:adce_chat/app/chat/chat_input_bar.dart';
import 'package:adce_chat/app/chat/chat_list.dart';
import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen._({this.chatBloc});
  final ChatBloc chatBloc;

  static Widget create({
    @required ChatUser currentUser,
    @required ChatUser otherUser,
    @required Database database,
  }) {
    ChatBloc chatBloc = ChatBloc(
      database: database,
      otherUser: otherUser,
      currentUser: currentUser,
    );
    return ChatScreen._(
      chatBloc: chatBloc,
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatBloc get bloc => widget.chatBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Material(
            child: bloc.otherUser.photoUrl == ''
                ? CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(bloc.otherUser.username,
                        style: TextStyle(color: Colors.indigo)),
                  )
                : CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: bloc.otherUser.photoUrl,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
            clipBehavior: Clip.hardEdge,
          ),
          title: Text(
            bloc.otherUser.username,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            bloc.otherUser.aboutMe,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChatList(bloc: bloc),
          ),
          ChatInputBar(bloc: bloc),
        ],
      ),
    );
  }
}
