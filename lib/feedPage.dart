import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medbook/welcomeScreen.dart';

import 'commentScreen.dart';
import 'myProfile.dart';
import 'newPostScreen.dart';
import 'setting.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
final id_accesso = 1;
// = FirebaseFirestore.instance.collection("subscribers").doc(id_accesso.toString()).get().then((querySnapshot) {
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
  'Urologia'
];
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

class FeedPage extends StatelessWidget {
  // FeedPage() {
  //   Firebase.initializeApp();
  //   // var db = FirebaseFirestore.instance.firestore();
  // }
  // @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    //   // TODO: scrolling di ListView dei post
    return MaterialApp(
      routes: {
        'welcome': (context) => WelcomeScreen(),},
      title: 'MedBook',
      theme: ThemeData(primaryColor: Colors.orange),
      home: MyFeedPage(title: 'MedBook'),
    );
  }
}

class MyFeedPage extends StatefulWidget {
  MyFeedPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  @override
  Widget build(BuildContext context) {
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
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfile(id_accesso)),
        );
      },
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
    //TODO scollegati da Firebase
    Navigator.of(context).popUntil(ModalRoute.withName('welcome'));
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  void _postWithMyHashtags() {
    // print("ciao Anto");
    //TODO pagina con i post di cui ho ricevuto la notifica perchè con il mio hashtag
  }

  void _search() {
    //TODO funzione di ricerca
  }

  _openDrawer() {}

  _newPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostScreen()),
    );
  }
}

Widget _buildBody(BuildContext context) {
  //TODO: estrai snapshot dal Cloud Firebase
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
  print(snapshot);
  return ListView(
    padding: const EdgeInsets.only(top: 5.0),
    //da giocarci dopo che visualizzo un post

    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  // final record = Record.fromMap(data);
  // print('provaaa');

  final record = Record.fromSnapshot(data);
  print(record.sexPatient); // record.map((data)=> print(data[1]));
  return Padding(
      // key: ValueKey(record.nameProfile),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle_outlined, size: 50.0),
              title: Text(record.nameProfile),
              subtitle: Text(record.timestamp),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile(record.id)),
                );
              },
            ),
            ListTile(
                title: Text('Età: ' +
                    (record.agePatient).toString() +
                    ', Sesso: ' +
                    (record.sexPatient) +
                    (record.hashtags.length == 0
                        ? ''
                        : "\n# " +
                            record.hashtags.toString().substring(
                                1, record.hashtags.toString().length - 1)) +
                    ""
                        "\n\n" +
                    record.post)),
            ListTile(
              title: record.comments.first.length > 0
                  ? record.comments.first.length > 1
                      ? Text(record.comments.length.toString() + ' commenti')
                      : Text(record.comments.length.toString() + ' commento')
                  : Text('Non ci sono commenti'),
              onTap: () {
                addComment(context, record.comments, record.reference, 0);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: ListTile(
                  onTap: () {
                    addComment(context, record.comments, record.reference, 1);
                  },
                  title: Center(child: Text('Commenta')),
                )),
                Container(
                    height: 30,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 2,
                    )),
                Flexible(
                    child: ListTile(
                        onTap: _activeNotifications,
                        title: Center(child: Text('Segui'))))
              ],
            )
          ])));
}

void addComment(context, List<dynamic> record1, reference, nuovoCommento) {
  //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
  // print('Ciao Lele' + record1.length.toString() );
  List<Map<String, dynamic>> record = new List<
      Map<String,
          dynamic>>(); // la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
  // print(nuovoCommento);
  // print(record1.first.length);
  if (record1.first.length != 0) {
    record1.forEach((data) => record.add({
          'nameProfile': data['nameProfile'],
          'comment': data['comment'],
          'upvote': data['upvote'],
          'downvote': data['downvote'],
          'idVotersLike': data['idVotersLike'],
          'idVotersDislike': data['idVotersDislike']
        }));
  }

  // if(record.length==0)
  //   record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0, 'idVotersLike':[0], 'idVotersDislike':[0]}];
  // print(record);
  if (record1.first.length != 0 || nuovoCommento == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentScreen(record, reference)),
    );
  }
}

// }

class Record {
  final String nameProfile;
  final String sexPatient;
  final String post;
  final int agePatient;
  final int numComment;
  final int id;
  final String timestamp;

  final List comments;
  final List hashtags;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : nameProfile = map['nameProfile'],
        sexPatient = map['sexPatient'],
        agePatient = map['agePatient'],
        post = map['post'],
        numComment = map['numComment'],
        id = map['id'],
        timestamp = getTimestamp(map['timestamp']),
        hashtags = map['hashtags'],
        comments = map['comments'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(),
            reference: snapshot.reference); //prende solo il primo post

  String toString() => "Record<$nameProfile:$post>";

  static String getTimestamp(Timestamp timestamp) {
    var time = timestamp.toDate();
    // print(time);
    final f = new DateFormat('dd/MM/yyyy').add_Hm();
    return f.format(time);
    // formatDate(time, [yyyy, '-', mm, '-', dd]);
    // return (time.day.toString()+"/"+time.month.toString()+"/"+time.year.toString()+" - "+time.hour.toString()+":"+time.minute);
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({Key key, this.onTap, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  // TODO: implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

void _activeNotifications() {}

String _visualizeComments(record) {
  print(record.comments.map((data) => data['comment'].toString()));
  return record.comments.map((data) => data['comment'][0].toString());
}
