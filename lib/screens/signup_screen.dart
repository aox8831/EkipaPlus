import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekipa_plus/resources/auth_methods.dart';
import 'package:ekipa_plus/screens/login_screen.dart';
import 'package:ekipa_plus/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/mobil_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  String selectedTeam = "0";
  String userSelectedTeam = "0";


  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose(); 
    _usernameController.dispose(); 
    _bioController.dispose();  
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

    void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });


    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        team: userSelectedTeam,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            children: [
              //Flexible(child: Container(), flex:2),
              //logo
              SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor, height: 64,),
              const SizedBox(height: 64),
              Center(
                child: Stack(
                  children: [
                    _image!=null?CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                    : const CircleAvatar(
                      radius: 64,
                      backgroundImage: 
                      NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo,),),), 
                  ],
                ),
              ),
              const SizedBox(height: 24,),
              TextFieldInput(
                textEditingController: _usernameController, 
                hintText: 'Vnesite uporabniško ime', 
                textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24,),
              TextFieldInput(
                textEditingController: _emailController, 
                hintText: 'Vnesite Vašo e-pošto', 
                textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24,),
                TextFieldInput(
                textEditingController: _passwordController, 
                hintText: 'Vnesite Vaše geslo', 
                textInputType: TextInputType.text,
                isPass: true,
                ),
                const SizedBox(height: 24,),
                TextFieldInput(
                textEditingController: _bioController, 
                hintText: 'Vnesite opis', 
                textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24,),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('teams').snapshots(),
                  builder: (context, snapshot){
                    List<DropdownMenuItem> teamItems =[];
                    if(!snapshot.hasData)
                    {
                      const CircularProgressIndicator();
                    }
                    else{
                      final teams = snapshot.data?.docs.reversed.toList();
                      teamItems.add(DropdownMenuItem(
                        value: "0",
                        child: Text('Izberi ekipo'),
                        ),);
                      for(var team in teams!){
                        teamItems.add(DropdownMenuItem(
                          value: team.id,
                          child: Text(team['ime']),
                          ),
                          );  
                      }
                    }
                    return DropdownButton(items: teamItems, onChanged: (teamValue) async {
                      setState(() {
                        selectedTeam = teamValue;
                      });
                      if (selectedTeam != '') {
                        final snapshot = await FirebaseFirestore.instance
                            .collection('teams')
                            .doc(selectedTeam)
                            .get();
                        userSelectedTeam = snapshot.get('ime');
                      }
                      print(selectedTeam);
                    },
                    value: selectedTeam,
                    isExpanded: false,
                    ); 
                  },
                ), 
                const SizedBox(height: 24,),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading ? const Center(child: CircularProgressIndicator(
                      color: primaryColor,
                    ),) : const Text('Vpiši se'),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                //Flexible(child: Container(), flex:2),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Že imaš račun?"),
                      padding: const EdgeInsets.symmetric(vertical: 8,)
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        child: Text("Vpiši se", style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8,)
                      ),
                    ),
                  ],
                ),
            ],
          ),
        )
      ),
    );
  }
}