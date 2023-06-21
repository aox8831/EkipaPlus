import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:ekipa_plus/models/user.dart' as model;

import '../screens/add_post.dart';
import '../screens/home.dart';
import '../screens/people.dart';
import '../screens/shop.dart';
import '../screens/stats.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Home(),
    AddPost(),
    Shop(),
    Stats(),
    People(),
  ];

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout, color: Colors.black,))],),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: GNav(
            iconSize: 20,
            backgroundColor: Colors.blue,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue.shade800,
            gap: 8,
            padding: EdgeInsets.all(12),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Domov',
              ),
              GButton(
                icon: Icons.drive_folder_upload,
                text: 'Dodaj',
              ),
              GButton(
                icon: Icons.shop,
                text: 'Nagrade',
              ),
              GButton(
                icon: Icons.auto_graph,
                text: 'Analiza',
              ),
              GButton(
                icon: Icons.people,
                text: 'Ekipe',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _navigateBottomBar,
          ),
        ),
      ),
    );
  }
}