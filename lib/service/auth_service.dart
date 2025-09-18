import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wander_crew/screen/login_screen.dart';
import 'package:wander_crew/screen/main_screen.dart';
import 'package:wander_crew/service/shared_pref.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final SharedPref _sharedPref = SharedPref.instance;

  Future<String?> register(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      _sharedPref.setEmail(email);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
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

  Future<String?> login(String email, String password, BuildContext context) async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _sharedPref.setEmail(email);
      await _sharedPref.getLogged() == false ? _sharedPref.setLogged(true) : null;
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
    }
    catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return 'Sign-in aborted';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final email = userCredential.user?.email;
      if (email != null) {
        _sharedPref.setEmail(email);
        await _sharedPref.setLogged(true);
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
    await FirebaseAuth.instance.signOut().then((value) {
      _sharedPref.setLogged(false);
      _sharedPref.setEmail(null);
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
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