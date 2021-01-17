import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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
  String monthBirth;
  String provincia;
  bool changedMonth = false;
  bool changedProvincia = false;
  bool openNow = true;
  List tmpTopic;

  File _image;

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 100);
      _image = File(image.path);
    uploadPic(context);
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100);

      _image = File(image.path);

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
    if(info['profileImgUrl']!=' ') downloadPic();
    return Column(
      children: <Widget>[
        _buildBodyHeader(),
        _entryField("Nome", _nameController),
        _entryField("Email", _emailController, isEnabled: false),
        _dateBirth(),
        _provinciaOrdine(),
        _entryField('Numero', _numOrdineController),
        _entryField('Specializzazioni', _specializzazioniController),
        _entryField('Topic di interesse', _topicController)
      ],
    );
  }

  Future uploadPic(BuildContext context) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        "profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage.jpg");
    Future<void> deleteTask = firebaseStorageRef.delete();
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");

    });

    StorageReference ref = FirebaseStorage.instance.ref();
    StorageTaskSnapshot addImg =
    await ref.child("profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage.jpg").putFile(_image).onComplete;
    if (addImg.error == null) {
      print("added to Firebase Storage");

      String downloadUrl = await addImg.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('subscribers').doc(FirebaseAuth.instance.currentUser.uid)
          .update({'profileImgUrl' : downloadUrl});
      FeedPage().getInfo().update('profileImgUrl', (value) => downloadUrl);
    }
  }

   downloadPic() {
     var imageRef = FirebaseStorage.instance.ref().child("profileImages/${FirebaseAuth.instance.currentUser.uid}/profileImage.jpg");
     final Directory tempDir = Directory.systemTemp;
     final File tempImageFile = File('${tempDir.path}/samplefilepath');
     final StorageFileDownloadTask downloadTask = imageRef.writeToFile(tempImageFile);
     _image = tempImageFile;

  }

  @override
  Widget build(BuildContext context) {
    tmpTopic = info['topic'];

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

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 30,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .05),
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


  Widget _dateBirth() {
    if (!changedMonth) monthBirth = info['monthBirth'];
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

  Widget _provinciaOrdine() {
    if (!changedProvincia) provincia = info['provinciaOrdine'];
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

      posts
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
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
      return '';
    } else {
      return
              'Specializzato in: ' +
              info['specializzazioni'].toString().substring(
                  1, info['specializzazioni'].toString().length - 1);
    }
  }

  titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
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
    return  SingleChildScrollView(child: Container(
        height: 150,
        child: Row(children: [
          GestureDetector(
              onTap: () => _showPicker(context),
              child: _image != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(info['profileImgUrl']),

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

              ),

          Expanded(child:
              ListTile(dense: true,

              title:
              info['provinciaOrdine'] == ' ' ? Text('')

                  :

                  Text(
                        'Ordine della provincia di \n' +
                            info['provinciaOrdine'],
                        textScaleFactor: 1.5,
                      ),
              subtitle:
              (info['dayBirth'] == ' ' &&
                      info['monthBirth'] == ' ' &&
                      info['yearBirth'] == ' ') ? Text('')

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

          )
    ));
  }


}
