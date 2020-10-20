import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbook/feedPage.dart';
// import 'package:flutter_login_signup/src/Widget/bezierContainer.dart';
import 'package:medbook/loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
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

  Widget _entryField(String title,  TextEditingController controller, {bool isPassword = false}) {
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
    return GestureDetector(
      onTap: _registerUser,
      child:
        Container(
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
            'Registrati',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
    ));


  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hai già un account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Login',
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
            // backgroundColor: Colors.white,
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
            // backgroundColor: Colors.white,
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          // TextSpan(
          //   text: 'rnz',
          //   style: TextStyle(color: Colors.white, fontSize: 30),
          // ),
        )
      ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Nome", nameController),
        _entryField("Cognome", surnameController),
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
            // Positioned(
            //   top: -MediaQuery.of(context).size.height * .15,
            //   right: -MediaQuery.of(context).size.width * .4,
            //   child: BezierContainer(),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.15),
                    _title(),
                    SizedBox(
                      height: 30,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .05),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  _registerUser() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: pwdController.text
      );
      try {
        await userCredential.user.sendEmailVerification();
        return userCredential.user.uid;
      } catch (e) {
        print("An error occured while trying to send email        verification");
        print(e.message);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La password è troppo semplice');
        Flushbar(
          message:'La password è troppo semplice' ,
          duration: Duration(seconds: 3),
        );
      } else if (e.code == 'email-already-in-use') {
        print('Esiste già un account registrato con questa e-mail');
        Flushbar(
          message:'Esiste già un account registrato con questa e-mail' ,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print(e);
    }

    CollectionReference users = FirebaseFirestore.instance.collection('subscribers');
    print(users.get().then((value) => print(value)));



    addUser();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => FeedPage()));
  }

  addUser() {
    // Call the user's CollectionReference to add a new user
    return  FirebaseFirestore.instance.collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'name': nameController.text+" "+surnameController.text,
      'id': 3
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
