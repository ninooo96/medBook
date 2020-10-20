// // import 'package:flutter/material.dart';
// //
// // class Setting extends StatelessWidget {
// //   final _nameController = TextEditingController();
// //   final _surnameController = TextEditingController();
// //   final _emailController = TextEditingController();
// //   final _pwdController = TextEditingController();
// //   final _pwdConfirmationController = TextEditingController();
// //   final _numOrdineController = TextEditingController();
// //   final _specializzazioniController = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Impostazioni'),
// //       ),
// //       body: _bodySetting(context),
// //     );
// //   }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medbook/feedPage.dart';

class Setting extends StatefulWidget {
  Setting({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _pwdConfirmationController = TextEditingController();
  final _numOrdineController = TextEditingController();
  final _specializzazioniController = TextEditingController();
  final _dayController = TextEditingController();
  final _yearController = TextEditingController();
  bool cambiaPassword = false;
  List<String> _months = [
    'Gennaio',
    'Febbraio',
    'Marzo',
    'Aprile',
    'Maggio',
    'Giugno',
    'Luglio',
    'Agosto',
    'Settembre',
    'Ottobre',
    'Novembre',
    'Dicembre'
  ];

  List<String> provinces = [
    "Agrigento",
        "Alessandria",
        "Ancona",
        "Aosta",
        "Ascoli Piceno",
        "L'Aquila",
        "Arezzo",
        "Asti",
        "Avellino",
        "Bari",
        "Bergamo",
        "Biella",
        "Belluno",
        "Benevento",
        "Bologna",
        "Brindisi",
        "Brescia",
        "Barletta-Andria-Trani",
        "Bolzano",
        "Cagliari",
        "Campobasso",
        "Caserta",
        "Chieti",
        "Carbonia-Iglesias",
        "Caltanissetta",
        "Cuneo",
        "Como",
        "Cremona",
        "Cosenza",
        "Catania",
        "Catanzaro",
        "Enna",
        "Forlì-Cesena",
        "Ferrara",
        "Foggia",
        "Firenze",
        "Fermo",
        "Frosinone",
        "Genova",
        "Gorizia",
        "Grosseto",
        "Imperia",
        "Isernia",
        "Crotone",
        "Lecco",
        "Lecce",
        "Livorno",
        "Lodi",
        "Latina",
        "Lucca",
        "Monza e Brianza",
        "Macerata",
        "Messina",
        "Milano",
        "Mantova",
        "Modena",
        "Massa e Carrara",
        "Matera",
        "Napoli",
        "Novara",
        "Nuoro",
        "Ogliastra",
        "Oristano",
        "Olbia-Tempio",
        "Palermo",
        "Piacenza",
        "Padova",
        "Pescara",
        "Perugia",
        "Pisa",
        "Pordenone",
        "Prato",
        "Parma",
        "Pistoia",
        "Pesaro and Urbino",
        "Pavia",
        "Potenza",
        "Ravenna",
        "Reggio Calabria",
        "Reggio Emilia",
        "Ragusa",
        "Rieti",
        "Roma",
        "Rimini",
        "Rovigo",
        "Salerno",
        "Siena",
        "Sondrio",
        "La Spezia",
        "Siracusa",
        "Sassari",
        "Savona",
        "Taranto",
        "Teramo",
        "Trento",
        "Torino",
        "Trapani",
        "Terni",
        "Trieste",
        "Treviso",
        "Udine",
        "Varese",
        "Verbano-Cusio-Ossola",
        "Vercelli",
        "Venezia",
        "Vicenza",
        "Verona",
        "Medio Campidano",
        "Viterbo",
        "Vibo Valentia",
  ];
  Map<String, dynamic> info = FeedPage().getInfo();
  String monthBirth; //= FirebaseAuth.instance.currentUser.providerData.;
  String provincia;
  bool changedMonth=false;
  bool changedProvincia = false;
  bool openNow = true;
  // bool openNowProvincia = true;
  // bool openNow = true;


  // Widget _backButton() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.pop(context);
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10),
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
  //             child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
  //           ),
  //           Text('Back',
  //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, bool isEnabled = true}) {
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
                  hintText: isPassword
                      ? cambiaPassword
                      ? 'Scrivi la tua nuova password'
                      : ''
                      : '',
                  enabled: isEnabled,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: _updateUserInfo,
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
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
            'Aggiorna le informazioni',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  // Widget _loginAccountLabel() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(vertical: 20),
  //       padding: EdgeInsets.all(15),
  //       alignment: Alignment.bottomCenter,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             'Hai già un account?',
  //             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           new GestureDetector(
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.push(context,
  //                     MaterialPageRoute(builder: (context) => LoginScreen()));
  //               },
  //               child: Text(
  //                 'Login',
  //                 style: TextStyle(
  //                     color: Color(0xfff79c4f),
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w600),
  //               )),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _title() {
  //   return RichText(
  //     textAlign: TextAlign.center,
  //     text: TextSpan(children: [
  //       TextSpan(
  //         text: 'Med ',
  //         style: GoogleFonts.portLligatSans(
  //           // backgroundColor: Colors.white,
  //           textStyle: Theme.of(context).textTheme.display1,
  //           fontSize: 40,
  //           fontStyle: FontStyle.italic,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.orange,
  //         ),
  //       ),
  //       TextSpan(
  //         text: 'Book',
  //
  //         style: GoogleFonts.portLligatSans(
  //           // backgroundColor: Colors.white,
  //           textStyle: Theme.of(context).textTheme.display1,
  //           fontSize: 40,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.black,
  //         ),
  //         // TextSpan(
  //         //   text: 'rnz',
  //         //   style: TextStyle(color: Colors.white, fontSize: 30),
  //         // ),
  //       )
  //     ]),
  //   );
  // }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        // Row(children: [
        _entryField("Nome", _nameController),
        // ]),
        _entryField("Email", _emailController, isEnabled: false),

        _entryField("Password", _pwdController,
            isPassword: true, isEnabled: cambiaPassword),
        _entryField('Conferma password', _pwdConfirmationController,
            isPassword: true, isEnabled: cambiaPassword),
        _dateBirth(),
        _provinciaOrdine(),
        _entryField('Numero', _numOrdineController),
        _entryField('Specializzazioni', _specializzazioniController)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    // provincia = info['provinciaOrdine'];

    if(openNow) {
      _nameController.text = FirebaseAuth.instance.currentUser.displayName;
      _emailController.text = FirebaseAuth.instance.currentUser.email;
      _dayController.text = info['dayBirth'].toString();
      _yearController.text = info['yearBirth'].toString();
      _specializzazioniController.text = info['specializzazioni'];
      _numOrdineController.text = info['numOrdine'].toString();
    }
      return Scaffold(
        appBar: AppBar(
          title: Text('Impostazioni'),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Cambia password'}.map((String choice) {
                    return PopupMenuItem<String>(
                        value: choice, child: Text(choice));
                  }).toList();
                })
          ],
        ),
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
                      // SizedBox(height: height * 0.15),
                      // _title(),
                      SizedBox(
                        height: 30,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(),
                      SizedBox(height: height * .05),
                      // _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
              // Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ),
      );
    }


// _registerUser() async {
//   try {
//     UserCredential userCredential = await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: emailController.text, password: pwdController.text);
//     try {
//       await userCredential.user.sendEmailVerification();
//       return userCredential.user.uid;
//     } catch (e) {
//       print(
//           "An error occured while trying to send email        verification");
//       print(e.message);
//     }
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       print('La password è troppo semplice');
//       Flushbar(
//         message: 'La password è troppo semplice',
//         duration: Duration(seconds: 3),
//       );
//     } else if (e.code == 'email-already-in-use') {
//       print('Esiste già un account registrato con questa e-mail');
//       Flushbar(
//         message: 'Esiste già un account registrato con questa e-mail',
//         duration: Duration(seconds: 3),
//       );
//     }
//   } catch (e) {
//     print(e);
//   }

//     CollectionReference users =
//         FirebaseFirestore.instance.collection('subscribers');
//     print(users.get().then((value) => print(value)));
//
//     addUser();
//     Navigator.of(context).pop();
//     Navigator.of(context).pop();
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => FeedPage()));
//   }
//
//   addUser() {
//     // Call the user's CollectionReference to add a new user
//     return FirebaseFirestore.instance
//         .collection('subscribers')
//         .doc(FirebaseAuth.instance.currentUser.uid)
//         .set({
//           'name': nameController.text + " " + surnameController.text,
//           'id': 3
//         })
//         .then((value) => print("User Added"))
//         .catchError((error) => print("Failed to add user: $error"));
//   }
// }

//   Widget _bodySetting(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return Container(
//         height: height,
//         child: Column(
//           children: <Widget>[
//             // Positioned(
//             //   top: -MediaQuery.of(context).size.height * .15,
//             //   right: -MediaQuery.of(context).size.width * .4,
//             //   child: BezierContainer(),
//             // ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               // child: SingleChildScrollView(
//                 child: Expanded(child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(height: height * 0.15),
//                     // _title(),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     // _emailPasswordWidget(),
//
//                       _entryField('Nome', _nameController),
//
//                       _entryField('Cognome', _surnameController)
//                     ])),
//                     // SizedBox(
//                     //   height: 20,
//                     // ),
//                     // _submitButton(),
//                     // SizedBox(height: height * .05),
//                     // _loginAccountLabel(),
//
//                 ),
//
//
//             // Positioned(top: 40, left: 0, child: _backButton()),
//           ],
//         ),
//
//     );
//   }
//
//
//
//   //   final height = MediaQuery.of(context).size.height;
//   //   return Scaffold(
//   //       body: Container(
//   //         height: height,
//   //           child: Stack(children: <Widget>[
//   //     Container(
//   //         padding: EdgeInsets.symmetric(horizontal: 20),
//   //         child: SingleChildScrollView(
//   //             child: Expanded(child: Column(
//   //       children: [
//   //         Expanded(child:
//   //           Row(children: [
//   //           _entryField('Nome', _nameController),
//   //             Container(
//   //                 height: 30,
//   //                 child: VerticalDivider(
//   //                   color: Colors.grey,
//   //                   thickness: 1,
//   //                 )),
//   //           _entryField('Cognome', _surnameController)
//   //         ])),
//   //         _entryField('E-mail', _emailController, isEnabled: false),
//   //         _entryField('Password', _pwdController, isPassword: true),
//   //         _entryField('Conferma Password', _pwdConfirmationController, isPassword: true),
//   //       ],
//   //     ))))
//   //   ])
//   //   ));
//   // }
//
//   Widget _entryField(String title, TextEditingController controller,
//       {bool isPassword = false, bool isEnabled = true}) {
//     return Container(child: Expanded(child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             title,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Expanded(child:
//           TextField(
//               controller: controller,
//               obscureText: isPassword,
//               decoration: InputDecoration(
//                 enabled: isEnabled,
//                   border: InputBorder.none,
//                   fillColor: Color(0xfff3f3f4),
//                   filled: true)))
//         ],
//     ))
//     );
//   }
// }

  void handleClick(String value) {
    setState(() {
      switch (value) {
        case 'Cambia password':
          cambiaPassword = true;
          // print(cambiaPassword);
          break;
      }
    });
  }

  // Widget _dateBirth() {
    // try {
    //   FirebaseFirestore.instance
    //       .collection('subscribers')
    //       .doc(FirebaseAuth.instance.currentUser.uid)
    //       .get()
    //       .then((user) =>
    //       _dateBirth2(
    //           user['dayBirth'], user['monthBirth'], user['yearBirth']));
    // } catch (e){
    //   _dateBirthAssente();
    // }

  //   return FutureBuilder<DocumentSnapshot>(
  //     future: FirebaseFirestore.instance
  //         .collection('subscribers')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get(),
  //     builder:
  //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //       if (snapshot.hasError) {
  //         return Text("Something went wrong");
  //       }
  //
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         Map<String, dynamic> user = snapshot.data.data();
  //         // monthBirth = user['monthBirth'];
  //
  //         return _dateBirth2(
  //             user['dayBirth'], user['monthBirth'], user['yearBirth']);
  //       }
  //
  //       return Text("loading");
  //     },
  //   );
  // }

  Widget _dateBirth() {
    // print(day.toString() + ' ' + month + ' ' + year.toString());

    if(!changedMonth) monthBirth = info['monthBirth'];
    print(monthBirth);
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Data di nascita',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // height: MediaQuery.of(context).size.height,

                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                              onTap: (){openNow = false;},
                       controller: _dayController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))),
                      Container(
                          height: 30,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          )),
                      DropdownButton(
                        // hint: Text('Please choose a location'),
                        // Not necessary for Option 1

                        value: monthBirth,
                        onChanged: (newValue) {
                          changedMonth =true;
                          setState(() {
                            monthBirth = newValue;
                          });
                        },
                        items: _months.map((monthBirth) {
                          return DropdownMenuItem(
                            child: new Text(monthBirth),
                            value: monthBirth,
                          );
                        }).toList(),
                      ),
                      Container(
                          height: 30,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                          )),
                      Expanded(
                          child: TextFormField(
                            onTap: (){openNow = false;},
                            controller: _yearController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true))),
                    ],
                  ))
            ]));
  }


  // Widget _provinciaOrdine() {
  //   return FutureBuilder<DocumentSnapshot>(
  //     future: FirebaseFirestore.instance
  //         .collection('subscribers')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get(),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<DocumentSnapshot> snapshot) {
  //       if (snapshot.hasError) {
  //         return Text("Something went wrong");
  //       }
  //
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         Map<String, dynamic> user = snapshot.data.data();
  //         // monthBirth = user['monthBirth'];
  //
  //         return _provinciaOrdine2(user['provinciaOrdine']);
  //       }
  //
  //       return Text("loading");
  //     },
  //   );
  // }

  Widget _provinciaOrdine() {

    if(!changedProvincia) provincia = info['provinciaOrdine'];
    print(provincia);
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ordine della provincia di:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),

              DropdownButton(
                // hint: Text('Please choose a location'),
                // Not necessary for Option 1

                value: provincia,
                onChanged: (newValue) {
                  changedProvincia = true;
                  setState(() {

                    provincia = newValue;
                  });
                },
                items: provinces.map((provincia) {
                  return DropdownMenuItem(
                    child: new Text(provincia),
                    value: provincia,
                  );
                }).toList(),
              ),
            ]));
  }






  _updateUserInfo() {
    if(cambiaPassword){
      //TODO cambio password
    }


    return  FirebaseFirestore.instance.collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'name': _nameController.text,
      'dayBirth': _dayController.text,
      'monthBirth': monthBirth,
      'yearBirth': _yearController.text,
      'specializzazioni':_specializzazioniController.text,
      'numOrdine' : _numOrdineController.text,
      'provinciaOrdine': provincia
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

  }
}
