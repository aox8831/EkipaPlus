import 'package:ekipa_plus/providers/user_provider.dart';
import 'package:ekipa_plus/responsive/mobil_screen_layout.dart';
import 'package:ekipa_plus/responsive/responsive_layout_screen.dart';
import 'package:ekipa_plus/responsive/web_screen_layout.dart';
import 'package:ekipa_plus/screens/login_screen.dart';
import 'package:ekipa_plus/screens/signup_screen.dart';
import 'package:ekipa_plus/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ekipa_plus/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(), 
        ),
      ],
      child: MaterialApp(
        title: 'EkipaPlus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home: const ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),
        //  webScreenLayout: WebScreenLayout(),
        //),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
             if(snapshot.connectionState == ConnectionState.active) {
                if(snapshot.hasData) {
                   return const ResponsiveLayout (mobileScreenLayout: MobileScreenLayout(),
                   webScreenLayout: WebScreenLayout(),
                   );
                } else if(snapshot.hasError){
                  return Center(child: Text('${snapshot.error}'),
                  ); 
                }
             }
             if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                )
              );
             }
    
             return const LoginScreen();
          },
        ),
      ),
    );
  }
}