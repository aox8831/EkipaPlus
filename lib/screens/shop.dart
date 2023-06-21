import 'package:ekipa_plus/screens/use_points.dart';
import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customBox('assets/lidl.png'),
                SizedBox(height: 20),
                customBox('assets/hervis_logo.png'),
                SizedBox(height: 20),
                customBox('assets/spar.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customBox(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      width: 350,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 300, height: 90),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UsePoints(),
                ),
              );
            },
            child: Text(
              'Uporabi točke',
              style: TextStyle(color: Colors.white), //Text color is usually white for elevated buttons
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, //Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), //Border radius
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), //Button padding
            ),
          ),
        ],
      ),
    );
  }
}