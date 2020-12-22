import 'dart:io';

import 'package:adce_chat/app/chat/chat_bloc.dart';
import 'package:adce_chat/app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

/// handles the input of the chat screen
/// send messages and photos
class ChatInputBar extends StatefulWidget {
  ChatInputBar({
    Key key,
    this.bloc,
  }) : super(key: key);

  final ChatBloc bloc;
  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  File imageFile;
  String imageUrl;
  int timestamp;
  Message message;

  ChatBloc bloc;

  @override
  void initState() {
    bloc = widget.bloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 20),
      child: Material(
        child: Container(
          child: Row(
            children: <Widget>[
              // send image Button
              Container(
                child: IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.image),
                  onPressed: sendImageMessage, //getImage,
                  color: Colors.indigo,
                ),
              ),
              // Edit text
              Flexible(
                child: Container(
                  child: TextField(
                    maxLines: 4,
                    minLines: 1,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              // send message button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: !isLoading
                    ? IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () =>
                            sendTextMessage(textEditingController.text, 0),
                        color: Colors.indigo,
                        iconSize: 30.0,
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
          width: double.infinity,
          margin: EdgeInsets.all(9),
        ),
        type: MaterialType.button,
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        elevation: 5.0,
      ),
    );
  }

  /// responsible for sending the message to the cloud
  void sendTextMessage(String content, int type) {
    // type: 0 = text, 1 = image
    if (content.trim() != '') {
      textEditingController.clear();

      bloc.sendMessage(content, type);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  /// called on pressing the photo button
  /// calls image_picker package to chose image from gallery
  void sendImageMessage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }
    // set loading state
    setState(() {
      isLoading = true;
    });

    bool result = await bloc.sendImageMessage(pickedFile, 1);
    if (result == true) {
      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'photo failed to upload');
      setState(() {
        isLoading = false;
      });
    }
  }
}
