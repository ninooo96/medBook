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

  // final _sessoController = TextEditingController();
  var sexPatient;
  final _etaController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  FirebaseMessaging _fcm = MyFeedPage().getFCM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
            child: Column(
          // scrollDirection: Axis.vertical,
          children: [
             drawDrawerHeader(),
            Expanded(child: _populateHashtags())
          ],
        )),
        appBar: AppBar(
          // leading: IconButton(
          //     icon: Icon(Icons.arrow_back_ios),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => FeedPage()),
          //       );
          //
          //     }
          // ),
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
    // return ListTile(
    //   title: Text('prova')
    // );
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
    print(specializzazioni.length);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemBuilder: (_, int index) => specializzazioni[index],
      itemCount: specializzazioni.length,
    );
    // return Scaffold(
    //   endDrawer: Drawer(
    //       child: ListView(
    //         children: [
    //           DrawerHeader(),
    //           _populateHashtags()
    //
    //         ],
    //       )
    //   ),
    // );
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
                    // icon: Icon(Icons.arrow_downward),
                    // iconSize: 24,
                    // elevation: 16,

                    // style: TextStyle(color: Colors.deepPurple),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.deepPurpleAccent,
                    // ),
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
                      //     child: TextFormField(
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //       width: 0.5,
                      //     )),
                      //     labelText: 'Sesso',
                      //   ),
                      //   controller: _sessoController,
                      // )
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
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // children: [_hashtagRow()],
                  title: _hashtagRow(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: _attachPhoto,
                    ),
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

  void _attachPhoto() {
    //TODO fai una foto o prendila dalla galleria
  }

  _hashtagRow() {
    List<String> text = [];
    if (hashtagPost.isNotEmpty) {
      for (var h in hashtagPost) {
        text.add(h);
      }
      // String hashtag = text[0]+', ';
      var tmp = text.toString();
      // print(tmp);
      return Text(
        tmp.substring(1, tmp.length - 1),
        textScaleFactor: 1.1,
      );
    }
    return Text('');
  }

  void _addTag() {
    // Scaffold.of(context).openEndDrawer();
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
    // var timestampTmp = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    print(hashtagPost);
    var timeTmp = Timestamp.now();
    // var timestamp = timeTmp.day.toString() +
    //     timeTmp.month.toString() +
    //     timeTmp.year.toString() +
    //     "-" +
    //     (timeTmp.hour).toString() +
    //     ":" +
    //     timeTmp.minute.toString() +
    //     ":" +
    //     timeTmp.second.toString();
    var time = timeTmp.toDate();
    // print(time);
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
    // await FirebaseFirestore.instance
    //     .collection('feed')
    //     .doc(nameProfile.toString().toLowerCase().replaceAll(' ', '') +
    //     "_" +
    //     FirebaseAuth.instance.currentUser.uid +
    //     "-" +
    //     timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'))
    //     .collection('tokens').doc(_fcm.getToken()).set({
    //   'key': _fcm.getToken(),
    //   'name': nameProfile.split(' ')[0]
    // }).then((value) => print('ok'));

    _saveDeviceToken() async {
      // Get the current user
      // FirebaseUser user = await _auth.currentUser();

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



        // await tokens.set({
        //   'token': fcmToken,
        //   'name': nameProfile // optional
        // });
        // await tokens.set({
        //   'token': fcmToken,
        //   'name': nameProfile, // optional
        // });
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
    // _saveDeviceToken();

    Navigator.of(context).pop();
    if(route == 0) //0==feedPage
      Navigator.pushReplacement( context, MaterialPageRoute(builder: (BuildContext context) => MyFeedPage()));
    else {
      print(ModalRoute.of(context).settings.name.toString() + "BOOOOh");
        FirebaseFirestore.instance
            .collection('subscribers')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get()
            .then((value) =>
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) => MyProfile(UserMB.fromSnapshot(value)))));
     }



    }
    //TODO send post to firebase

}
