import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class UsePoints extends StatefulWidget {
  @override
  _UsePointsState createState() => _UsePointsState();
}

class _UsePointsState extends State<UsePoints> {
  int? _selectedPoints;
  String message = 'Porabili ste toliko točk. S tem ste pridobili naslednjo kodo s popustom: HdjshHDJS8432 .';
  int _number = 0;

  Future sendEmail(
    String username,
    String email,
    String message,
  ) async {
    final serviceId = 'service_40xqmi7';
    final templateId = 'template_77cz3mk';
    final publicKey = '78N6rknq5sb_n4-4N';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'user_name': username,
          'user_message': message,
          'user_email': email,
        }
      }),
    );
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

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    _getNumber();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Izberi in porabi točke'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 20)),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: StreamBuilder<QuerySnapshot>(
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
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: Text('Uporabi točke'),
                onPressed: () async {
                  await sendEmail(user.username,
                  user.email, 
                  message
                );
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}