import 'package:adce_chat/app/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key key, @required this.chatUser, @required this.onTap})
      : super(key: key);

  final ChatUser chatUser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
      child: ListTile(
        leading: Material(
          child: chatUser.photoUrl == ''
              ? CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo,
                )
              : CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl: chatUser.photoUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          clipBehavior: Clip.hardEdge,
        ),
        title: Text(
          '${chatUser.username}',
          // diffrent style if there is unseen message
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          '${chatUser.aboutMe}',
          // diffrent style if there is unseen message
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
    );
  }
}
