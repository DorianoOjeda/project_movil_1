import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthData {
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String> getUserId();
}

class AuthRemote extends AuthData {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<String> getUserId() async {
    return _auth.currentUser!.uid;
  }
}
