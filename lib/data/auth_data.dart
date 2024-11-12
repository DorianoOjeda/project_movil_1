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
      _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      throw Exception('Error during sign up: $e');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Error during sign up: $e');
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

  Future<void> setUserName(String name) async {
    await _auth.currentUser!.updateDisplayName(name);
  }

  User? get currentUser => _auth.currentUser;
  String get currentUserName => _auth.currentUser!.displayName!;
  String get currentUserEmail => _auth.currentUser!.email!;
}
