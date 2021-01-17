import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medbook/myProfile.dart';
import 'package:medbook/user.dart';
import 'package:medbook/utility.dart';

import 'feedPage.dart';

class NewPostScreen extends StatefulWidget {
  int route;
  NewPostScreen(int route){
    this.route = route;
  }
  @override
  _NewPostScreenState createState() => _NewPostScreenState(route);
}

class _NewPostScreenState extends State<NewPostScreen> {
  int route;
  _NewPostScreenState(int route){
    this.route = route;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final hashtagPost = [];
  final _textController = TextEditingController();

  var sexPatient;
  final _etaController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  FirebaseMessaging _fcm = FeedPage().getFCM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
            child: Column(
          children: [
             drawDrawerHeader(),
            Expanded(child: _populateHashtags())
          ],
        )),
        appBar: AppBar(

          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),

          ),
          title: Text('Nuovo Post'),
          actions: [Container()],
        ),
        body: _buildBody(context));
  }

  Widget drawDrawerHeader() {
    return Container(
      width: double.infinity ,
      height: 150.0,
      child: DrawerHeader(
          child: Text('   Specializzazioni',
              textScaleFactor: 1.8,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          padding: EdgeInsets.symmetric(vertical: 25)),
    );
  }

  Widget _populateHashtags() {

    List<ListTile> specializzazioni = [];
    for (var hashtag in hashtags) {
      specializzazioni.add(ListTile(
        title: Text(
          hashtag,
          textScaleFactor: 1.5,
        ),
        onTap: () {
          setState(() {
            if (hashtagPost.contains(hashtag)) {
              hashtagPost.remove(hashtag);
            } else
              hashtagPost.add(hashtag);
          });
        },
      ));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemBuilder: (_, int index) => specializzazioni[index],
      itemCount: specializzazioni.length,
    );

  }

  Widget _buildBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: DropdownButtonFormField<String>(
                    isDense: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                      width: 0.5,
                    ))),
                    hint: Text('Seleziona il sesso'),
                    value: sexPatient,

                    onChanged: (String newValue) {
                      setState(() {
                        sexPatient = newValue;
                      });
                    },
                    items: <String>['Maschile', 'Femminile']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                  )

                      ),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        )),
                        labelText: 'Età'),
                    controller: _etaController,
                  )),
                ]),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                      )),
                      hintText: 'Scrivi il tuo post...',
                    ),
                    controller: _textController,
                    maxLines: double.maxFinite.floor(),
                    keyboardType: TextInputType.multiline,
                  ),
                ),

                ListTile(
                  title: _hashtagRow(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.tag),
                      onPressed: _addTag,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendPost,
                    ),
                  ],
                )
              ],
            )));
  }

  _hashtagRow() {
    List<String> text = [];
    if (hashtagPost.isNotEmpty) {
      for (var h in hashtagPost) {
        text.add(h);
      }
      var tmp = text.toString();
      return Text(
        tmp.substring(1, tmp.length - 1),
        textScaleFactor: 1.1,
      );
    }
    return Text('');
  }

  void _addTag() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _sendPost() {
    FirebaseFirestore.instance
        .collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) => _sendPost2(value['name']));
  }

  void _sendPost2(nameProfile) async {
    var age;
    try {
      age = int.parse(_etaController.text);
    } catch (e) {
      _etaController.text = '';
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_outlined),
            SizedBox(
              width: 20,
            ),
            Expanded(child: Text("L'età deve essere in formato numerico."))
          ],
        ),
      ));
      return;
    }
    var timeTmp = Timestamp.now();
    var time = timeTmp.toDate();
    final f = new DateFormat('dd/MM/yyyy').add_Hms();
    var timestamp = f.format(time);

    var newPost = {
      'nameProfile': nameProfile,
      'name': nameProfile.split(' ')[0],
      'surname': nameProfile.split(' ').sublist(1).join(' '),
      'post': _textController.text,
      'agePatient': age,
      'sexPatient': sexPatient.toString(),
      'comments': [Map()],
      'id': FirebaseAuth.instance.currentUser.uid,
      'timestamp': timeTmp,
      'hashtags': hashtagPost,
      'profileImgUrl': info['profileImgUrl'],
      'listTokens': [],
      'token': await FeedPage().getFCM().getToken(),
      'yet_opened':false
    };

    FeedPage().setNoNotification(true);

    await FirebaseFirestore.instance
        .collection('feed')
        .doc(nameProfile.toString().toLowerCase().replaceAll(' ', '') +
            "_" +
            FirebaseAuth.instance.currentUser.uid +
            "-" +
            timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'))
        .set(newPost);
    _saveDeviceToken() async {
      // Get the token for this device
      String fcmToken = await _fcm.getToken();

      // Save it to Firestore
      if (fcmToken != null) {
        FirebaseFirestore.instance
            .collection('feed')
            .doc(nameProfile.toString().toLowerCase().replaceAll(' ', '') +
                "_" +
                FirebaseAuth.instance.currentUser.uid +
                "-" +
                timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'))
            .update({
          'listTokens': [
            {'name': nameProfile, 'token': fcmToken}
          ]
        });

      }
    }
    var reference = FirebaseFirestore.instance
        .collection('feed')
        .doc(nameProfile.toString().toLowerCase().replaceAll(' ', '') +
        "_" +
        FirebaseAuth.instance.currentUser.uid +
        "-" +
        timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'));

    Utility().saveDeviceToken(reference, nameProfile, FirebaseAuth.instance.currentUser.uid.toString());


    Navigator.of(context).pop();
    if(route == 0) //0==feedPage
      Navigator.pushReplacement( context, MaterialPageRoute(builder: (BuildContext context) => MyFeedPage()));
    else {
        FirebaseFirestore.instance
            .collection('subscribers')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get()
            .then((value) =>
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) => MyProfile(UserMB.fromSnapshot(value)))));
     }



    }


}
