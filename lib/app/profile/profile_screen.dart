import 'package:adce_chat/app/models/chat_user.dart';
import 'package:adce_chat/app/profile/profile_bloc.dart';
import 'package:adce_chat/services/database.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen._({Key key, this.bloc}) : super(key: key);
  final ProfileBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required ChatUser user,
    @required String uid,
    @required Database database,
  }) {
    ProfileBloc bloc = ProfileBloc(database: database, user: user, uid: uid);
    return ProfileScreen._(bloc: bloc);
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc get bloc => widget.bloc;

  bool isLoading = false;
  String photoUrl;
  String username;
  String aboutMe;
  ArsProgressDialog progressDialog;

  @override
  void initState() {
    photoUrl = bloc.user?.photoUrl;
    aboutMe = bloc.user?.aboutMe;
    username = bloc.user?.username;

    progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
      animationDuration: Duration(milliseconds: 500),
    );
    super.initState();
  }

  void save() async {
    if (photoUrl == null) {
      Fluttertoast.showToast(msg: 'You must upload a photo');
      return;
    } else if (username == null) {
      Fluttertoast.showToast(msg: 'You must write a username');
      return;
    } else if (aboutMe == null) {
      Fluttertoast.showToast(msg: 'You must write an about me text');
      return;
    }
    ChatUser newUser = ChatUser(
      username: username,
      id: bloc.uid,
      aboutMe: aboutMe,
      photoUrl: photoUrl,
    );
    await bloc.saveProfile(newUser);
    Fluttertoast.showToast(msg: 'Saved');
  }

  void uploadProfileImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }
    progressDialog.show();
    String downloadUrl = await bloc.uploadProfileImage(pickedFile);
    progressDialog.dismiss();
    if (downloadUrl != null) {
      photoUrl = downloadUrl;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: 'photo failed to upload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bloc.user == null ? 'Create profile' : 'Setting',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Avatar
            Container(
              child: Center(
                child: photoUrl != null
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                            width: 90.0,
                            height: 90.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: photoUrl,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        onPressed: () => uploadProfileImage(),
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey[200],
                        iconSize: 30.0,
                      ),
              ),
              width: double.infinity,
              margin: EdgeInsets.all(20.0),
            ),
            // Input
            Column(
              children: <Widget>[
                // Username
                Container(
                  child: Text('Username'),
                  margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                ),
                Container(
                  child: TextFormField(
                    initialValue: username,
                    decoration: InputDecoration(
                      hintText: 'yacine_benali',
                      contentPadding: EdgeInsets.all(5.0),
                    ),
                    onChanged: (value) => username = value,
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),
                // About me
                Container(
                  child: Text('About me'),
                  margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                ),
                Container(
                  child: TextFormField(
                    initialValue: aboutMe,
                    decoration: InputDecoration(
                      hintText: 'Fun, like travel and play PES...',
                      contentPadding: EdgeInsets.all(5.0),
                    ),
                    onChanged: (value) => aboutMe = value,
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),

            // Button
            Container(
              child: RaisedButton(
                onPressed: () => save(),
                child: Text(
                  'UPDATE',
                  style: TextStyle(fontSize: 16.0),
                ),
                splashColor: Colors.transparent,
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
              ),
              margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
            ),
          ],
        ),
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
      ),
    );
  }
}
