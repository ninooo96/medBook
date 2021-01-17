import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medbook/feedPage.dart';

import 'package:medbook/welcomeScreen.dart';

final app = Firebase.app('MedBook');

void main() => runApp(App());

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  bool isSignedIn = false;




  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }


    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        isSignedIn = false;
      } else {
        print('User is signed in!');

        isSignedIn = true;

      }
    });
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    }



  @override
  Widget build(BuildContext context) {


    // Show error message if initialization failed
    if (_error) {
      return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }
   return isSignedIn ? FeedPage() :  MaterialApp(
          home: Scaffold(body: WelcomeScreen()));

  }

  Widget SomethingWentWrong() {
    print('error');
    return Text('error');
  }

  Widget Loading() {
    print('loading');
    return Container();
  }
}


