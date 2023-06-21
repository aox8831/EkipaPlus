import 'package:ekipa_plus/screens/signup_screen.dart';
import 'package:ekipa_plus/utils/colors.dart';
import 'package:ekipa_plus/widgets/text_field_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobil_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}): super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();  
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
            )); 
    } else {
      showSnackBar(context, res); 
    }
    setState(() {
        _isLoading = false;
      });
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen(),),);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex:2),
              //logo
              Text('EkipaPlus', style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
              const SizedBox(height: 64),
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
              ElevatedButton(
                onPressed: loginUser,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Vpiši se', style: TextStyle(color: Colors.blue)),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- 20 is the radius of the border
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 12,),
              Flexible(child: Container(), flex:2),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Še nimate računa?", style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: navigateToSignup,
                    child: Text("Ustvari račun", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

