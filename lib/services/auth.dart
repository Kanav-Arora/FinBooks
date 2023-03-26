import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signup(String email, String password) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    debugPrint(email + password);
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      debugPrint(res.user?.uid.toString());
    } catch (e) {
      rethrow;
    }
  }
}
