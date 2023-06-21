import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekipa_plus/providers/user_provider.dart';
import 'package:ekipa_plus/resources/firestore_methods.dart';
import 'package:ekipa_plus/responsive/mobil_screen_layout.dart';
import 'package:ekipa_plus/utils/colors.dart';
import 'package:ekipa_plus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'home.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  int _selectedPoints = 0;
  String _selectedUser = 'User1';
  String _text = '';
  String selectedUser = '0';
  String userSelectedUser = '';
  int userGivePoints = 0;
  int _number = 0;
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('init deluje');

  }

  void postImage(
    String uid2,
    String uid,
    String user,
    String text,
    String username,
    String profImage,
    int points,
    int points2,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try{
      String postContent = 'Osebi ' + user + ' podeljujem ' + points2.toString() + ' točk ker: ' + text;
      final documentReference = FirebaseFirestore.instance.collection('users').doc(uid);
      documentReference.update({
        'points_give': points,  
      });
      final documentReference2 = FirebaseFirestore.instance.collection('users').doc(uid2);
      final snapshot = await documentReference2.get();
      final pointsGet = snapshot.data()?['points_get'] as int;
      documentReference2.update({
        'points_get': pointsGet+points2,  
      });
      String res = await FireStoreMethods().uploadPost(postContent, _file!, uid, username, profImage);

      if(res == "success") {
        setState(() {
          _isLoading = true;
        });
        showSnackBar(context, 'Objavljeno');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MobileScreenLayout()));
      } else {
        setState(() {
          _isLoading = true;
        });
        showSnackBar(context, res);
      }
    } catch(e){
      showSnackBar(context, e.toString());
    }
  }

  Future<void> _getNumber() async {
    final User user = Provider.of<UserProvider>(context).getUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = snapshot.data();
    print(snapshot.data());
    final number = data?['points_give'] as int;
    setState(() {
      _number = number;
    });
  }

  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: const Text('Dodaj sliko'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Slikaj'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(
                ImageSource.camera,
              );
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Naloži iz galerije'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(
                ImageSource.gallery,
              );
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Prekliči'),
            onPressed: ()  {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  _imageWidget() {
    if (_file == null) {
      return NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png');
    } else {
      return MemoryImage(_file!);
    }
  } 

  void clearImage() {
    setState(() {
      _file = null;

    });
  }

  @override
  void dispose(){
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    _getNumber();
    print(_number);
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Objavi pohvalo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(selectedUser, user.uid, userSelectedUser ,_textController.text, user.username, user.photoUrl, _number-_selectedPoints, _selectedPoints),
            child: const Text(
              'Objavi',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        children: [
          _isLoading ? const LinearProgressIndicator() : const SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
              ),
              IconButton(
                onPressed: () => _selectImage(context),
                icon: const Icon(Icons.upload),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imageWidget(),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.0),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              List<DropdownMenuItem<int>> numberItems = [];
              if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
          } else {
            final users = snapshot.data!.docs;
            for (int i = 0; i <= _number; i++) {
              numberItems.add(DropdownMenuItem(
                value: i,
                child: Text(i.toString()),
              ));
            }
            return DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Izberite točke',
                border: OutlineInputBorder(),
              ),
              items: numberItems,
              onChanged: (value) {
                _selectedPoints = value!;
              },
              isExpanded: true,
              value: _selectedPoints,
            );
          }
        },
      ),
      SizedBox(height: 16.0),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('team', isEqualTo: user.team)
            .snapshots(),
        builder: (context, snapshot) {
          List<DropdownMenuItem> usersItems = [];
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final users = snapshot.data?.docs.reversed.toList();
            usersItems.add(
              DropdownMenuItem(
                value: "0",
                child: Text('Izberi osebo'),
              ),
            );
            for (var user in users!) {
              usersItems.add(
                DropdownMenuItem(
                  value: user.id,
                  child: Text(user['username']),
                ),
              );
            }
          }
          return DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Izberi uporabnika',
              border: OutlineInputBorder(),
            ),
            items: usersItems,
            onChanged: (userValue) async {
              setState(() {
                selectedUser = userValue;
              });
              if (selectedUser != '') {
                final snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(selectedUser)
                    .get();
                userSelectedUser = snapshot.get('username');
              }
              print(selectedUser);
              print(userSelectedUser);
            },
            value: selectedUser,
            isExpanded: true,
          );
        },
      ),
      SizedBox(height: 16.0),
      TextFormField(
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Vnesi sporočilo',
          border: OutlineInputBorder(),
        ),
        maxLines: null,
        onChanged: (String value) {
          setState(() {
            _text = value;
          });
        },
      ),
    ],
  ),
);
}
}