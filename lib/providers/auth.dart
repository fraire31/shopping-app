import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  bool _isAuth = false;
  Map _roles = {};

  bool get isAuth {
    return _isAuth;
  }

  Map get roles {
    return _roles;
  }

  bool isAdmin() {
    return _roles.containsKey('admin');
  }

  Future<IdTokenResult> getToken() async {
    return await _auth.currentUser!.getIdTokenResult(true);
  }

  void setRoles() async {
    final token = await getToken();
    if (token.claims != null) {
      _roles = token.claims!['roles'];
    }
  }

  bool isFavorite(List? favoriteList) {
    if (favoriteList == null) {
      return false;
    }

    final userUid = _auth.currentUser!.uid;
    return favoriteList.contains(userUid);
  }

  List? updateFavoriteList(List? favoriteList, bool isFavorite) {
    final userUid = _auth.currentUser!.uid;

    if (isFavorite) {
      favoriteList!.remove(userUid);
    } else {
      if (favoriteList == null) {
        favoriteList = [userUid];
      } else {
        favoriteList.add(userUid);
      }
    }

    return favoriteList;
  }

  Future<void> setCustomClaimsRoles(String uid) async {
    try {
      HttpsCallable callable = await _functions.httpsCallable('setRole');
      final results = await callable.call({'uid': uid});
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    String? message;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _isAuth = true;
        await setCustomClaimsRoles(userCredential.user!.uid).catchError((e) {
          print(e);
        });
        setRoles();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      }
    } catch (e) {
      print(e);
      message = 'Something went wrong.';
    }

    return {'message': message};
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    String? message;

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await _firestore.collection('users').add({
          'id': value.user!.uid,
          'email': value.user!.email,
          'roles': {'user': true}
        }).catchError((e) {
          print(e);
        });

        return value;
      });

      if (userCredential.user != null) {
        _isAuth = true;
        await setCustomClaimsRoles(userCredential.user!.uid).catchError((e) {
          print(e);
        });
        _roles = {'user': true};
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
    } catch (e) {
      message = 'Something went wrong.';
      print(e);
    }
    return {'message': message};
  }

  Future<void> logout() async {
    _isAuth = false;
    _roles = {};
    await _auth.signOut();
  }
}
