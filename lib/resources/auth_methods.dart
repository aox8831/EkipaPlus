import 'dart:typed_data';
import 'package:ekipa_plus/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekipa_plus/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; 

Future<model.User> getUserDetails() async {
  User currentUser = _auth.currentUser!;

  DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

  return model.User.fromSnap(snap);
}

Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required String team,
    required Uint8List file 
  }) async{
    String res="Error";
    try{
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null ||
          team != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          team: team,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);

        

        res="success";
       }
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "Pojavila se je napaka";

    try{
      if(email.isEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Izpolnite vsa polja!";
      }
    } catch(err){
      res= err.toString();
    }
    return res;
  }

}