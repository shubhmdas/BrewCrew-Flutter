import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user from firebase
  MyUser? _createUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // setting a stream for auth changes
  Stream<MyUser?> get authStream {
    return _auth.authStateChanges().map(_createUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _createUser(result.user);
    } catch(e) {
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmail({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _createUser(result.user);
    } catch(e) {
      return e;
    }
  }

  // register with email and password
  Future registerWithEmail({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // update user data with dummy data when a new user is created
      await DatabaseService(uid: result.user!.uid).updateUserData(sugars: '0', name: 'new user', strength: 100);

      return _createUser(result.user);
    } catch(e) {
      return e;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch(e) {
      return null;
    }
  }

}