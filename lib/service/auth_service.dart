import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wander_crew/screen/login_screen.dart';
import 'package:wander_crew/screen/main_screen.dart';
import 'package:wander_crew/service/shared_pref.dart';
import 'package:wander_crew/service/user_service.dart';

class AuthService {
  final SharedPref _sharedPref = SharedPref.instance;

  Future<String?> register(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _sharedPref.setEmail(email);

      // Save user profile in Firestore
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final newUser = UserService()
          .createDefaultUser(uid: uid, email: email);
      await UserService().saveUser(newUser);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen()));
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _sharedPref.setEmail(email);
      await _sharedPref.getLogged() == false
          ? _sharedPref.setLogged(true)
          : null;

      // Backfill Firestore if missing
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (!userDoc.exists) {
        final fallbackUser = UserService()
            .createDefaultUser(uid: uid, email: email);
        await UserService().saveUser(fallbackUser);
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return 'Invalid login credentials.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return 'Sign-in aborted';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final email = userCredential.user?.email;
      final uid = userCredential.user?.uid;


      if (email != null) {
        _sharedPref.setEmail(email);
        await _sharedPref.setLogged(true);

        //Firestore backfill for Google users
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(email).get();
        if (!userDoc.exists && uid != null) {
          final fallbackUser = UserService().createDefaultUser(
            uid: uid,
            email: email
          );
          await UserService().saveUser(fallbackUser);
        }

      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      await _sharedPref.setLogged(false);
      await _sharedPref.setEmail(null);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    }
  }



  Future<String?> getEmail() async {
    String? email;
    try {
      email = await _sharedPref.getEmail();
      return email;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      return e.message.toString();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
