import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, bottom: 60.0, left: 15.0, right: 15.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), // specify the desired radius
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: users.orderBy('points_get', descending: true).limit(3).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // Render the header for points_get
                              return ListTile(
                                title: Text(
                                  'Uporabniki z največ prejetimi točkami:',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              );
                            }

                            int idx = index - 1;
                            DocumentSnapshot document = snapshot.data!.docs[idx];
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            final String name = data['username'] ?? 'No Name';
                            final int pointsGet = data['points_get'] ?? 0;

                            Color color;
                            switch (idx) {
                              case 0:
                                color = Color(0xFFD4AF37); // Gold color
                                break;
                              case 1:
                                color = Color(0xFFC0C0C0); // Silver color
                                break;
                              case 2:
                                color = Color(0xFFCD7F32); // Bronze color
                                break;
                              default:
                                color = Colors.black;
                            }

                            return ListTile(
                              leading: Text('${idx + 1}', style: TextStyle(color: color, fontSize: 18)),
                              title: Text(name, style: TextStyle(color: color, fontSize: 18)),
                              subtitle: Text('Prejete točke: $pointsGet', style: TextStyle(color: color, fontSize: 16)),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), // specify the desired radius
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: users.orderBy('points_give', descending: true).limit(3).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // Render the header for points_g
                              // Render the header for points_give
                            return ListTile(
                              title: Text(
                                'Uporabniki z največ točkami, ki jih lahko dajo:',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            );
                          }

                          int idx = index - 1;
                          DocumentSnapshot document = snapshot.data!.docs[idx];
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          final String name = data['username'] ?? 'No Name';
                          final int pointsGive = data['points_give'] ?? 0;

                          Color color;
                          switch (idx) {
                            case 0:
                              color = Color(0xFFD4AF37); // Gold color
                              break;
                            case 1:
                              color = Color(0xFFC0C0C0); // Silver color
                              break;
                            case 2:
                              color = Color(0xFFCD7F32); // Bronze color
                              break;
                            default:
                              color = Colors.black;
                          }

                          return ListTile(
                            leading: Text('${idx + 1}', style: TextStyle(color: color, fontSize: 18)),
                            title: Text(name, style: TextStyle(color: color, fontSize: 18)),
                            subtitle: Text('Točke za oddajo: $pointsGive', style: TextStyle(color: color, fontSize: 16)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}