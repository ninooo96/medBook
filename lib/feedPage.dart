import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medbook/record.dart';
import 'package:intl/intl.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/search.dart';
import 'package:medbook/user.dart' as userMedbook;
import 'package:medbook/user.dart';
import 'package:medbook/welcomeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'commentScreen.dart';
import 'myProfile.dart';
import 'newPostScreen.dart';
import 'setting.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// final id_accesso = 2;
// = Firebase
// Firestore.instance.collection("subscribers").doc(id_accesso.toString()).get().then((querySnapshot) {
//    querySnapshot.data()['nameProfile'];});
final hashtags = [
  'Dermatologia',
  'Ortopedia',
  'Ematologia',
  'Geriatria',
  'Igiene',
  'Pediatria',
  'Psichiatria',
  'Cardiologia',
  'Neurologia',
  'Urologia',
  'Oculistica',
  'Radiodiagnostica',
  'Nefrologia',
  'Reumatologia',
  'Allergologia',
  'Ginecologia',
  'Otorinolaringoiatria',
  'Audiologia'
];

Map<String, dynamic> info;
// String nameProfileid = 'Prova';
// final dummySnapshot = [
//   {
//     'id':1,
//     'nameProfile': 'Antonio Gagliostro',
//     'agePatient': 67,
//     'sexPatient': 'Male',
//     'post':
//         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//     'numComment': 2,
//     'comments': [
//       {
//         'id':2,
//         'nameProfile': 'Chiara Del Re',
//         'comment': 'ciao',
//         'upvote': 3,
//         'downvote': 7
//       },
//       {
//         'id':4,
//         'nameProfile': 'Dott. House',
//         'comment': 'ciao Antonio',
//         'upvote': 2,
//         'downvote': 7
//       },
//     ]
//   },
//   {
//     'id':2,
//     'nameProfile': 'Chiara Del Re',
//     'agePatient': 79,
//     'sexPatient': 'Female',
//     'post': 'Diagnosi2',
//     'numComment': 1,
//     'comments': [
//       {
//         'id':3,
//         'nameProfile': 'Dott.ssa Peluche',
//         'comment': 'ciao Chiara',
//         'upvote': 5,
//         'downvote': 5
//       },
//     ]
//   },
//   {
//     'id':1,
//     'nameProfile': 'Antonio Gagliostro',
//     'agePatient': 67,
//     'sexPatient': 'Male',
//     'post':
//         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//     'numComment': 0,
//     'comments': []
//   },
//   {
//     'id':1,
//     'nameProfile': 'Antonio Gagliostro',
//     'agePatient': 67,
//     'sexPatient': 'Male',
//     'post':
//         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//     'numComment': 0,
//     'comments': []
//   },
// ];
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   print('on background $message');
//   FirebaseMessaging fbm = FirebaseMessaging();
//
//   fbm.configure(
//       onMessage: (msg) {
//         print(msg);
//         return;
//       },
//       onLaunch: (msg) {
//         print(msg);
//         return;
//       },
//       onResume: (msg) {
//         print(msg);
//         return;
//       },
//       onBackgroundMessage: myBackgroundMessageHandler
//   );
// }

class FeedPage extends StatelessWidget {
  // FeedPage() {
  //   Firebase.initializeApp();
  //   // var db = FirebaseFirestore.instance.firestore();
  // }
  Map<String, dynamic> getInfo() {
    return info;
  }

  void setInfo(infoNew) {
    info = infoNew;
  }

  // // @override
  // Widget _info(){
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
  //         info = {'name': user['name'],
  //           'provinciaOrdine':user['provinciaOrdine'],
  //           'dayBirth': user['dayBirth'],
  //           'monthBirth':user['monthBirth'],
  //           'yearBirth': user['yearBirth'],
  //           'numeroOrdine': user['numeroOrdine']
  //         };
  //         return Text('ciao');
  //       }
  //
  //       return Text("loading");
  //     },
  //   );
  // }

  Widget build(BuildContext context) {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    FirebaseFirestore.instance.collection('subscribers').doc(
        FirebaseAuth.instance.currentUser.uid).get().then((user) =>
    info = {'name': user['name'],
      'provinciaOrdine': user['provinciaOrdine'],
      'dayBirth': user['dayBirth'],
      'monthBirth': user['monthBirth'],
      'yearBirth': user['yearBirth'],
      'numOrdine': user['numOrdine'],
      'specializzazioni': user['specializzazioni'],
      'topic': user['topic'],
      'profileImgUrl': user['profileImgUrl'], // non è user
      'token'
      'id': FirebaseAuth.instance.currentUser.uid

    });

    // print(info);
    // Firebase.initializeApp();
    //   // scrolling di ListView dei post
    return MaterialApp(
      routes: {
        'welcome': (context) => WelcomeScreen(),
        'feed': (context) => FeedPage(),
        // 'myProfile': (context) => MyProfile
        // 'myProfile' : (context) =>MyProfile(Record.fromMap(info))//info['name'], info['id'])
      },
      title: 'MedBook',
      theme: ThemeData(primaryColor: Colors.orange),
      home: MyFeedPage(title: 'MedBook'),
    );
  }
}

class MyFeedPage extends StatefulWidget {
  MyFeedPage({Key key, this.title}) : super(key: key);
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final String title;

  FirebaseMessaging getFCM(){
    return _fcm;
  }


  @override
  _MyFeedPageState createState() => _MyFeedPageState(_fcm);
}

class _MyFeedPageState extends State<MyFeedPage> {
  String _profileImageUrl = ' ';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _fcm;

  _MyFeedPageState(FirebaseMessaging _fcm){
    this._fcm = _fcm;
  }



  @override
  void initState() {
    super.initState();

    // ...

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     content: ListTile(
        //       title: Text(message['notification']['title']),
        //       subtitle: Text(message['notification']['body']),
        //     ),
        //     actions: <Widget>[
        //       FlatButton(
        //         child: Text('Ok'),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ],
        //   ),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _fcm.subscribeToTopic('feed');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _newPost();
        }, //new post page
        backgroundColor: Colors.orange,
        splashColor: Colors.yellow,
      ),
      drawer: Drawer(
          child: Column(
            children: <Widget>[
              drawDrawerHeader(),
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: _drawerTile()),
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                        title: Text(
                          'Esci',
                          textScaleFactor: 1.5,
                        ),
                        tileColor: Colors.red,
                        onTap: _logout,
                      )))
            ],
          )),
      appBar: CustomAppBar(
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
          title: Center(child: Text(widget.title)),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: _search),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: _postWithMyHashtags,
            ),
          ],
        ),
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => PostTile()),
        //   );
        // },
      ),
      body: _buildBody(context),
    );
  }

  Widget drawDrawerHeader() {
    return Container(
      height: 90.0,
      child: DrawerHeader(
        // child: Text('Specializzazioni',
        //     textScaleFactor: 1.8,
        //     textAlign: TextAlign.left,
        //     style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(
              color: Colors.orange,
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          padding: EdgeInsets.symmetric(vertical: 25)),
    );
  }

// _drawerTile(List<Widget> drawerTile) {
//   FirebaseFirestore.instance
//       .collection('subscribers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
//       print(value['name'] +
//           " " +
//           value['surname']));
//   FirebaseFirestore.instance
//       .collection('subscribers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
//        _drawerTile2(value['name'] +
//       " " +
//       value['surname']));
// }
  // FutureBuilder<DocumentSnapshot>(
  //     future: FirebaseFirestore.instance
  //         .collection('subscribers')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get(),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<DocumentSnapshot> snapshot) {
  //       return _drawerTile2(snapshot.data.data()['name'] +
  //           " " +
  //           snapshot.data.data()['surname']);
  //     }
  // );
  // }
  _drawerTile() {
    List<Widget> drawerTile = [];
    drawerTile.add(ListTile(
      title: Text(
        'Home',
        textScaleFactor: 1.5,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
      },
    ));
    drawerTile.add(Divider(
      thickness: 2,
    ));
    drawerTile.add(ListTile(
        title: Text(
          'Il mio profilo',
          textScaleFactor: 1.5,
        ),
        onTap: myProfile
    ));
    drawerTile.add(Divider(
      thickness: 2,
    ));
    drawerTile.add(ListTile(
      title: Text(
        'Impostazioni',
        textScaleFactor: 1.5,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Setting()),
        );
      },
    ));
    drawerTile.add(Divider(
      thickness: 2,
    ));

    return drawerTile;
  }

  _logout() {
    Navigator.of(context).popUntil(ModalRoute.withName('welcome'));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    FirebaseAuth.instance.signOut();
  }

  void _postWithMyHashtags() {
    // print("ciao Anto");
    //TODO pagina con i post di cui ho ricevuto la notifica perchè con il mio hashtag
  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }

  _openDrawer() {}

  _newPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostScreen()),
    );
  }

  myProfile() {
    FirebaseFirestore.instance
        .collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) =>
        myProfile2(UserMB.fromSnapshot(value)));
  }

  myProfile2(UserMB user) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyProfile(user),
        )
    );
  }


  Widget _buildBody(BuildContext context) {
    //estrai snapshot dal Cloud Firebase
    // List<Map> snapshot = dummySnapshot;
    //
    // return _buildList(context, snapshot);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        // print('OK');
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    // print(snapshot);
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      //da giocarci dopo che visualizzo un post

      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  String profileImageOnPost(String id) {
    String tmp = ' ';
    FirebaseFirestore.instance.collection('subscribers').doc(id).get().then((
        value) =>
    tmp = value['profileImgUrl']);
    // print(tmp+ 'boh');
    return tmp;
  }

  Future<bool> profileImageUrl(Map<String, dynamic> record) async {
    // print(record['id']);
    await FirebaseFirestore.instance.collection('subscribers')
        .doc(record['id'])
        .get()
        .then(
            (value) =>
            record.update('profileImgUrl', (value2) => value['profileImgUrl']));
    // print(record['profileImgUrl']+' PROVAAAA');


  }

  urlImageProfile(UserMB record) {
    CollectionReference users = FirebaseFirestore.instance.collection(
        'subscribers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(record.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        // if (snapshot.hasError) {
        //   return Text("Something went wrong");
        // }

        Map<String, dynamic> data = snapshot.data.data();
        // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        ClipRRect(borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.hardEdge,
          child: Image.network(record.profileImgUrl, height: 50, width: 50),);


        // return Text("loading");
      },
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    // final record = Record.fromMap(data);
    // print('provaaa');

    Map<String, dynamic> tmp = data.data();
    profileImageUrl(tmp);

    final record = Record.fromSnapshot(data);

    // print(record.sexPatient); // record.map((data)=> print(data[1]));
    print(record.comments);

    return PostTile(data, context);
    // return Padding(
    //   // key: ValueKey(record.nameProfile),
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
    //     child: Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(color: Colors.grey),
    //           borderRadius: BorderRadius.circular(15.0),
    //         ),
    //         child: Column(children: <Widget>[
    //           ListTile(
    //             leading: record.profileImgUrl==' ' ? Icon(Icons.account_circle_outlined,size: 50) : ClipRRect(borderRadius: BorderRadius.circular(20),clipBehavior: Clip.hardEdge, child: Image.network(record.profileImgUrl, height: 50, width:50)),
    //             title: Text(record.nameProfile),
    //             subtitle: Text(record.timestamp),
    //             onTap: () {
    //               var snap = FirebaseFirestore.instance.collection('subscribers').doc(record.id).get().then((value) {
    //                 UserMB user = UserMB.fromSnapshot(value);
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => MyProfile(user)),//.nameProfile, record.id.toString())),
    //                 );
    //               });
    //
    //
    //             },
    //           ),
    //           ListTile(
    //               title: Text('Età: ' +
    //                   (record.agePatient).toString() +
    //                   (record.sexPatient == 'null'
    //                       ? ''
    //                       : (', Sesso: ' + (record.sexPatient))) +
    //                   (record.hashtags.length == 0
    //                       ? ''
    //                       : "\n# " +
    //                       record.hashtags.toString().substring(
    //                           1, record.hashtags.toString().length - 1)) +
    //                   ""
    //                       "\n\n" +
    //                   record.post)),
    //           ListTile(
    //             title: record.comments.first.length > 0
    //                 ? record.comments.first.length > 1
    //                 ? Text(record.comments.length.toString() + ' commenti')
    //                 : Text(record.comments.length.toString() + ' commento')
    //                 : Text('Non ci sono commenti'),
    //             onTap: () {
    //
    //               setState(() {
    //                 addComment(context, record.comments, record.reference, 0);
    //                 print(record.comments);
    //               });
    //             },
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Flexible(
    //                   child: ListTile(
    //                     onTap: () {
    //                       addComment(context, record.comments, record.reference, 1);
    //                     },
    //                     title: Center(child: Text('Commenta')),
    //                   )),
    //               Container(
    //                   height: 30,
    //                   child: VerticalDivider(
    //                     color: Colors.grey,
    //                     thickness: 2,
    //                   )),
    //               Flexible(
    //                   child: ListTile(
    //                     // onTap: _activeNotifications,
    //                       title: Center(child: Text('Segui'))))
    //             ],
    //           )
    //         ])));
  }

// void addComment(context, List<dynamic> record1, reference, nuovoCommento) {
//   //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
//   // print('Ciao Lele' + record1.length.toString() );
//   List<Map<String, dynamic>> record2 = new List<
//       Map<String,
//           dynamic>>(); // la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
//   // print(nuovoCommento);
//   // print(record1.first.length);
//   if (record1.first.length != 0) {
//     record1.forEach((data) =>
//         record2.add({
//           'nameProfile': data['nameProfile'],
//           'comment': data['comment'],
//           'upvote': data['upvote'],
//           'downvote': data['downvote'],
//           'idVotersLike': data['idVotersLike'],
//           'idVotersDislike': data['idVotersDislike'],
//           'profileImgUrl': data['profileImgUrl']
//         }));
//   }
//
//   // if(record.length==0)
//   //   record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0, 'idVotersLike':[0], 'idVotersDislike':[0]}];
//   // print(record);
//   if (record1.first.length != 0 || nuovoCommento == 1) {
//     // record1 = record;
//     // Navigator.of(context).pop();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => CommentScreen(record2, reference)),
//     );
//   }
// }


}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({Key key, this.onTap, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  // implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

void _activeNotifications() {}

String _visualizeComments(record) {
  print(record.comments.map((data) => data['comment'].toString()));
  return record.comments.map((data) => data['comment'][0].toString());
}


