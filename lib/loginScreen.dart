import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medbook/feedPage.dart';
import 'package:medbook/registerScreen.dart';


class LoginScreen extends StatefulWidget {

  GoogleSignIn _googleSignIn = GoogleSignIn();
  var _auth = FirebaseAuth.instance;
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return
      GestureDetector(
        onTap: _loginButton,
        child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return Center(
      child: IconButton(
        icon: Image.asset(
          'assets/images/logo_google.png',
          width: 30,
          height: 30,
        ),
        onPressed: () {
          _loginGoogle();

          },

      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Non hai un account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
                child: Text(
                  'Registrati',
                  style: TextStyle(
                      color: Color(0xfff79c4f),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: 'Med ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 40,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            color: Colors.orange,
          ),
        ),
        TextSpan(
          text: 'Book',

          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        )
      ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", emailController),
        _entryField("Password", pwdController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  GestureDetector(
                    onTap: resetPassword,
                    child:
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Password dimenticata?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  )),
                  _divider(),
                  Divider(),
                  _googleButton(),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  void _loginButton() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: pwdController.text

      );
      if(userCredential.user.emailVerified) {
        DocumentSnapshot ds = await FirebaseFirestore.instance.collection(
            "subscribers").doc(FirebaseAuth.instance.currentUser.uid).get();
        if (!ds.exists) addUser2();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedPage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Non è registrato nessun utente con questa e-mail');

      } else if (e.code == 'wrong-password') {
        print('Password errata');
        Flushbar(
          message: 'Password errata',
          duration: Duration(seconds: 3),
        ).show(context);

      }
    }
  }

  Future<UserCredential> _loginGoogle() async {
    // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credentialG = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );



      // Once signed in, return the UserCredential,
      UserCredential _user = await FirebaseAuth.instance.signInWithCredential(credentialG);
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("subscribers").doc(FirebaseAuth.instance.currentUser.uid).get();
      if(_user.user.emailVerified) {
        DocumentSnapshot ds = await FirebaseFirestore.instance.collection(
            "subscribers").doc(FirebaseAuth.instance.currentUser.uid).get();
        if (!ds.exists) addUser(_user);
      }
      Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new FeedPage()));
      return _user;
    }


  addUser(UserCredential user) {
    // Call the user's CollectionReference to add a new user
    return  FirebaseFirestore.instance.collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'name': user.user.displayName,
      'id': user.user.uid,
      'dayBirth': ' ',
      'monthBirth': ' ',
      'yearBirth' : ' ',
      'numOrdine': ' ',
      'provinciaOrdine':' ',
      'specializzazioni': [],
      'profileImgUrl': ' ',
      'topic' : [],
      'verified' : ' '
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

    @override
    Future<void> resetPassword() async {
     try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text);
      }catch(e){
        print("Inserisci l'e-mail che hai usato per la registrazione");
        Flushbar(
          message: "Inserisci l'e-mail che hai usato per la registrazione",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    }

  addUser2() {
    // Call the user's CollectionReference to add a new user
    return  FirebaseFirestore.instance.collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'id': FirebaseAuth.instance.currentUser.uid,
      'dayBirth': ' ',
      'monthBirth': ' ',
      'yearBirth' : ' ',
      'numOrdine': ' ',
      'provinciaOrdine':' ',
      'specializzazioni': ' ',
      'profiloImgUrl':' ',
      'topic' : [],
      'verified' : ' '
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

}

