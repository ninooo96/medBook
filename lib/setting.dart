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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:image_picker_ui/image_picker_handler.dart';
import 'package:medbook/feedPage.dart';
import 'package:medbook/welcomeScreen.dart';



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
  final _topicController = TextEditingController();
  final _dayController = TextEditingController();
  final _yearController = TextEditingController();
  bool cambiaPassword = false;



  List<String> _months = [
    ' ',
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
    " ",
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
  FirebaseMessaging _fcm = FeedPage().getFCM();
  String monthBirth; //= FirebaseAuth.instance.currentUser.providerData.;
  String provincia;
  bool changedMonth = false;
  bool changedProvincia = false;
  bool openNow = true;
  List tmpTopic;

  //user_image
  File _image;

  // AnimationController _controllerImage;
  // ImagePickerHandler imagePicker;

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 100);
    // setState(() {
      _image = File(image.path);
    // });
    uploadPic(context);
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100);

    // setState(() {
      _image = File(image.path);

    // }
    // );
    uploadPic(context);
  }


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
              onTap: () {
                openNow = false;
              },
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
            'Aggiorna le informazioni',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }


  Widget _emailPasswordWidget() {
    print(info);
    if(info['profileImgUrl']!=' ') downloadPic();
    return Column(
      children: <Widget>[
        // Row(children: [

        _buildBodyHeader(),
        _entryField("Nome", _nameController),
        // ]),
        _entryField("Email", _emailController, isEnabled: false),

        // _entryField("Password", _pwdController,
        //     isPassword: true, isEnabled: cambiaPassword),
        // _entryField('Conferma password', _pwdConfirmationController,
        //     isPassword: true, isEnabled: cambiaPassword),
        _dateBirth(),
        _provinciaOrdine(),
        _entryField('Numero', _numOrdineController),
        _entryField('Specializzazioni', _specializzazioniController),
        _entryField('Topic di interesse', _topicController)
      ],
    );
  }

  Future uploadPic(BuildContext context) async {
    // String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        "profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage.jpg");
    // firebaseStorageRef.delete();
    Future<void> deleteTask = firebaseStorageRef.delete();
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");

      // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });

    StorageReference ref = FirebaseStorage.instance.ref();
    StorageTaskSnapshot addImg =
    await ref.child("profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage.jpg").putFile(_image).onComplete;
    if (addImg.error == null) {
      print("added to Firebase Storage");

      String downloadUrl = await addImg.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('subscribers').doc(FirebaseAuth.instance.currentUser.uid)
          .update({'profileImgUrl' : downloadUrl});
      // FeedPage().setInfo({'profileImgUrl': downloadUrl});
      FeedPage().getInfo().update('profileImgUrl', (value) => downloadUrl);
    }
  }

   downloadPic() {
     var imageRef = FirebaseStorage.instance.ref().child("profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage.jpg");
     final Directory tempDir = Directory.systemTemp;
     final File tempImageFile = File('${tempDir.path}/samplefilepath');
     final StorageFileDownloadTask downloadTask = imageRef.writeToFile(tempImageFile);
     _image = tempImageFile;
     // downloadTask.future.then((snapshot) =>
     //     setState(()
     // {
     //   _image = tempImageFile;
     // }
     //     ));
           //
    // //actual downloading stuff
    // final StorageReference ref = FirebaseStorage.instance.ref().child("profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage");
    // final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
    // // print(image);
    // final int byteNumber = (await downloadTask.future).totalByteCount;
    // print(byteNumber);
    // image = file;


  }

  //
  // try {
  //   print(firebase_storage.FirebaseStorage.instance.ref().child('profileImages').child(FirebaseAuth.instance.currentUser.uid).child('imageProfile.JPG'));
  //   await firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('profileImages')
  //       .child(FirebaseAuth.instance.currentUser.uid)
  //       .child('imageProfile.JPG')
  //       .getStorage (file);
  // } catch (e) {
  //   print('exception');
  //   print(e);
  // e.g, e.code == 'canceled'
  // }

  @override
  Widget build(BuildContext context) {
    print('prova');

    tmpTopic = info['topic'];
    // uploadPic(context);

    // var blob = info['image'];
    // print('ciaoo1);');
    //   var image = Base64Codec().decode(blob.toString());
    // print('ciaoo2');

    // _image = FileImage(FirebaseImage('gs://bucket123/userIcon123.jpg'));//image
    // print('prova1');
    // Uint8List image = Base64Codec().decode(info['image']);
    // print(info['image']);
    // _image = writeAsBytes(info['image'].bytes);
    // _image = File(Image.memory(info['image'].))
    // _image= File.fromRawPath(image);
    final height = MediaQuery.of(context).size.height-50;
    // provincia = info['provinciaOrdine'];

    if (openNow) {
      _nameController.text = info['name'];
      _emailController.text = FirebaseAuth.instance.currentUser.email;
      _dayController.text = info['dayBirth'].toString();
      _yearController.text = info['yearBirth'].toString();
      _specializzazioniController.text = info['specializzazioni']
          .toString()
          .substring(1, info['specializzazioni'].toString().length - 1);
      _topicController.text = info['topic']
          .toString()
          .substring(1, info['topic'].toString().length - 1);
      _numOrdineController.text = info['numOrdine'].toString();
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          //
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: _openDrawer,
          // ),

        ),
        title: Text('Impostazioni'),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Cambia password', 'Elimina utente'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              })
        ],
      ),
      body: SingleChildScrollView(child:  Container(
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
      )
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
          UserInfo userInfo = FirebaseAuth.instance.currentUser.providerData[0];
          if (cambiaPassword && userInfo.providerId == 'google.com') {
            Flushbar(
              message:
                  "Non è possibile cambiare la password da qui se hai fatto l'accesso con Google",
              duration: Duration(seconds: 5),
            ).show(context);
            setState(() {
              cambiaPassword = false;
            });
          }
          // print(cambiaPassword);
          break;

        case 'Elimina utente':
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Sicuro di voler eliminare l'account?"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            textScaleFactor: 1.5,
                          )),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteAccount();
                          },
                          child: Text(
                            'Sì',
                            textScaleFactor: 1.5,
                          ))
                    ],
                  ),
                );
              });
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

    if (!changedMonth) monthBirth = info['monthBirth'];
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
                          onTap: () {
                            openNow = false;
                          },
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
                      changedMonth = true;
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
                          onTap: () {
                            openNow = false;
                          },
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
    if (!changedProvincia) provincia = info['provinciaOrdine'];
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

  //
  //
  // void fcmSubscribe() {
  //   firebaseMessaging.subscribeToTopic('TopicToListen');
  // }
  //
  // void fcmUnSubscribe() {
  //   firebaseMessaging.unsubscribeFromTopic('TopicToListen');
  // }

  _updateUserInfo() {
    UserInfo userInfo = FirebaseAuth.instance.currentUser.providerData[0];
    if (cambiaPassword && userInfo.providerId == 'google.com') {
      Flushbar(
        message:
            "Non è possibile cambiare la password da qui se hai fatto l'accesso con Google",
        duration: Duration(seconds: 5),
      ).show(context);
      setState(() {
        cambiaPassword = false;
      });
    }
    if (cambiaPassword && userInfo.providerId == 'password') {
      @override
      Future<void> resetPassword() async {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
              email: FirebaseAuth.instance.currentUser.email);
        } catch (e) {
          print(
              "Abbiamo inviato un'e-mail alla tua casella di posta con il link per reimpostare a password");
          Flushbar(
            message:
                "Abbiamo inviato un'e-mail alla tua casella di posta con il link per reimpostare a password",
            duration: Duration(seconds: 5),
          ).show(context);
          Future.delayed(Duration(seconds: 6), () {
            Navigator.of(context).pop();
          });
        }
      }

      resetPassword();
    }
    List<String> specializzazioni = [];
    List<String> topic = [];
    if(_specializzazioniController.text.contains(',')) {
      List<String> tmp = _specializzazioniController.text.split(', ');
      for(var elem in tmp){
        elem = elem.trim();
        specializzazioni.add(elem[0].toUpperCase()+elem.substring(1));
      }

    }
    else if(_specializzazioniController.text.length>2){
      specializzazioni.add(_specializzazioniController.text[0].toUpperCase()+_specializzazioniController.text.substring(1));
    }

    if(_topicController.text.contains(',')) {
      List<String> tmp = _topicController.text.split(', ');
      for(var elem in tmp){
        elem = elem.trim();
        topic.add(elem[0].toUpperCase()+elem.substring(1));
      }

    }
    else if(_topicController.text.length>2){
      topic.add(_topicController.text.trim()[0].toUpperCase()+_topicController.text.trim().substring(1));
    }

    if(tmpTopic!=' '){
      for(var top in tmpTopic){
        _fcm.unsubscribeFromTopic(top.toString());
      }
    }

    if(!topic.isEmpty){
      for(var top in topic){
        _fcm.subscribeToTopic(top.toString());
        print(top.toString());
      }
    }

    Map<String, dynamic> newInfo = {
      'name': _nameController.text,
      'dayBirth': _dayController.text,
      'monthBirth': monthBirth,
      'yearBirth': _yearController.text,
      'specializzazioni': specializzazioni,
      'topic': topic,
      'numOrdine': _numOrdineController.text,
      'provinciaOrdine': provincia,
      'profileImgUrl' : info['profileImgUrl']
    };
    FeedPage().setInfo(newInfo);


    Flushbar(
      message: "Informazioni aggiornate",
      duration: Duration(seconds: 3),
    ).show(context);

    return FirebaseFirestore.instance
        .collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(newInfo)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  _deleteAccount() {
    try {
      CollectionReference posts = FirebaseFirestore.instance.collection('feed');

      // Future<void> deletePosts() {
      //   return posts
      //       // .doc(FirebaseAuth.instance.currentUser.uid)
      //       .where()
      //       .delete()
      //       .then((value) => print("User Deleted"))
      //       .catchError((error) => print("Failed to delete user: $error"));
      // }
      // deleteUser();

      posts
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        print(value);
        value.docs.forEach((element) {
          element.reference.delete();
        });
      });
      deleteUser();
      FirebaseAuth.instance.currentUser.delete();
      Navigator.of(context).popUntil(ModalRoute.withName('welcome'));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      //close app and remove all data
    } catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
        showDialog(
            context: context,
            builder: (context) {
              UserInfo userInfo =
                  FirebaseAuth.instance.currentUser.providerData[0];
              TextEditingController _emailReauthController =
                  TextEditingController();
              TextEditingController _passwordReauthController =
                  TextEditingController();

              if (userInfo.providerId == 'password') {
                return AlertDialog(
                  title: Text(
                      'È necessario effettuare nuovamente il login con il tuo account.'),
                  content: Column(
                    children: [
                      _entryField('E-mail', _emailReauthController),
                      _entryField('Password', _passwordReauthController),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Annulla',
                                textScaleFactor: 1.5,
                              )),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteAccountAfterReauth(
                                    _emailReauthController.text,
                                    _passwordReauthController.text);
                              },
                              child: Text(
                                'Ok',
                                textScaleFactor: 1.5,
                              ))
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return AlertDialog(
                    title: Text(
                        'È necessario effettuare nuovamente il login con il tuo account.'),
                    content: IconButton(
                      icon: Image.asset(
                        'assets/images/logo_google.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () async {
                        final GoogleSignInAccount googleUser =
                            await GoogleSignIn().signIn();

                        // Obtain the auth details from the request
                        final GoogleSignInAuthentication googleAuth =
                            await googleUser.authentication;

                        // Create a new credential
                        final GoogleAuthCredential credentialG =
                            GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                      },
                    ));
              }
            });
      }
    }
  }

  _deleteAccountAfterReauth(String email, String pwd) async {
    // Create a credential
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pwd);
// Reauthenticate
    await FirebaseAuth.instance.currentUser
        .reauthenticateWithCredential(credential.credential);

    deleteUser();
    FirebaseAuth.instance.currentUser.delete();
    Navigator.of(context).popUntil(ModalRoute.withName('welcome'));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  Future<void> deleteUser() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('subscribers');
    return users
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  String _specializzazioni() {
    print(info['specializzazioni'].toList() == []);
    if (info['specializzazioni'].length == 0) {
      return '';//ListTile(title: Text(' '));
    } else {
      return
        // ListTile(
        //   dense: true,
        //   title: Text(
              'Specializzato in: ' +
              info['specializzazioni'].toString().substring(
                  1, info['specializzazioni'].toString().length - 1);
    }
  }

  titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      // You do not need to check if i is larger than splitStr length, as your for does that for you
      // Assign it back to the array
      splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join(' ').toString();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBodyHeader() {
    // if (buildedHeader) {
    //   return Container();
    // } else {
    //   buildedHeader = true;
    // print(_controllerImage.value);
    return  SingleChildScrollView(child: Container(
        height: 150,
        child: Row(children: [
          GestureDetector(
              onTap: () => _showPicker(context),
              child: _image != null
                  ? CircleAvatar(
                      //quello con 2 R ha una forma circolare
                      // borderRadius: BorderRadius.circular(50),

                      radius: 50,
                      // child: Image.network(info['profileImgUrl']),
                      backgroundImage: NetworkImage(info['profileImgUrl']),
                      // ? ClipRRect(
                      //     //quello con 2 R ha una forma circolare
                      //     // borderRadius: BorderRadius.circular(50),
                      //
                      //     child: Image(
                      //         image: FileImage(_image),
                      //         width: 500,
                      //         height: 500,
                      //         fit: BoxFit.fitHeight),
                      // radius: 1000,
                      //       backgroundImage: FileImage(_image)
                      // Image.file(_image,
                      //     width: 100, height: 100, fit: BoxFit.fitHeight),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ))
              // CircleAvatar(radius: 50,child: Image.asset('assets/images/logo_google.png')),
              // Image.asset('assets/images/logo_google.png')

              // icon: Icon(_image == null ? Icons.account_circle_outlined : ExactAssetImage(_image.path) , size: 100.0),
              ),

          // SingleChildScrollView(
          Expanded(child:
              ListTile(dense: true,
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: [
              title:
              info['provinciaOrdine'] == ' ' ? Text('')
                  // ? ListTile(
                  //     dense: true,
                  //     title: Text(''),
                  //   )
                  :
                  // ListTile(
                  //     dense: true,
                  //     title:
                  Text(
                        'Ordine della provincia di \n' +
                            info['provinciaOrdine'],
                        textScaleFactor: 1.5,
                      ),
              subtitle:
              (info['dayBirth'] == ' ' &&
                      info['monthBirth'] == ' ' &&
                      info['yearBirth'] == ' ') ? Text('')
                  // ? ListTile(dense: true, title: Text(''))
                  // : ListTile(
                  //     dense: true,
                  //     title:
              :
                      Text(
                        '\nData di nascita: ' +
                            info['dayBirth'].toString() +
                            '/' +
                            info['monthBirth'].trim() +
                            '/' +
                            info['yearBirth'].toString() +'\n\n'+

              _specializzazioni(),textScaleFactor: 1.2,)))
            ],
            // ]
            //   leading: Container(
            //     width:100,
            // alignment: Alignment.centerLeft,
            // child: GestureDetector(
            //       onTap: () => _showPicker(context),
            //
            //       child:
            //       _image != null
            //           ? ClipRRect(
            //               //quello con 2 R ha una forma circolare
            //               // borderRadius: BorderRadius.circular(50),
            //
            //           child: Image(image: FileImage(_image),width: 500, height: 500,fit: BoxFit.fitHeight),
            //         // radius: 1000,
            //         //       backgroundImage: FileImage(_image)
            //               // Image.file(_image,
            //               //     width: 100, height: 100, fit: BoxFit.fitHeight),
            //             )
            //           : Container(
            //               decoration: BoxDecoration(
            //                   color: Colors.grey[200],
            //                   borderRadius: BorderRadius.circular(50)),
            //               width: 100,
            //               height: 100,
            //               child: Icon(
            //                 Icons.camera_alt,
            //                 color: Colors.grey[800],
            //               ))
            //       // CircleAvatar(radius: 50,child: Image.asset('assets/images/logo_google.png')),
            //       // Image.asset('assets/images/logo_google.png')
            //
            //       // icon: Icon(_image == null ? Icons.account_circle_outlined : ExactAssetImage(_image.path) , size: 100.0),
            //       )),
            // title: info['provinciaOrdine'] == ' '
            //     ? Text('')
            //     : Text(
            //         'Ordine della provincia di \n' + info['provinciaOrdine']),
            // subtitle: (info['dayBirth'] == ' ' &&
            //         info['monthBirth'] == ' ' &&
            //         info['yearBirth'] == ' ')
            //     ? Text('')
            //     : Text('\nData di nascita: \n' +
            //         info['dayBirth'].toString() +
            //         '/' +
            //         info['monthBirth'] +
            //         '/' +
            //         info['yearBirth'].toString() +
            //         _specializzazioni()),
            // isThreeLine: true,
          )
    ));
  }

// @override
// userImage(File _image) {
//   setState(() {
//     this._image = _image;
//   });
// }
}
