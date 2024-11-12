import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'id': _auth.currentUser!.uid,
        'email': email,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setName(String name) async {
    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
