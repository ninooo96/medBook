import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medbook/openNotification.dart';
import 'package:medbook/record.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/search.dart';
import 'package:medbook/notification.dart' as notification;
import 'package:medbook/user.dart';
import 'package:medbook/welcomeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'commentScreen.dart';
import 'myProfile.dart';
import 'newPostScreen.dart';
import 'notification.dart';
import 'setting.dart';

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
bool noNotification = false;
final FirebaseMessaging _fcm = FirebaseMessaging();

class FeedPage extends StatelessWidget {

  FirebaseMessaging getFCM(){
    return _fcm;
  }

  Map<String, dynamic> getInfo() {
    return info;
  }

  void setInfo(infoNew) {
    info = infoNew;
  }

  void setNoNotification(boolean){
    noNotification = boolean;
  }


  Widget build(BuildContext context) {
    //   // scrolling di ListView dei post
    return MaterialApp(
      routes: {
        'welcome': (context) => WelcomeScreen(),
        'feed': (context) => MyFeedPage(),
      },
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
  _MyFeedPageState createState() => _MyFeedPageState(_fcm);
}

class _MyFeedPageState extends State<MyFeedPage> {
  String _profileImageUrl = ' ';
  bool newNotification = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _fcm;

  _MyFeedPageState(FirebaseMessaging _fcm){


    this._fcm = _fcm;
  }

  void initializeInfo() async {
    noNotification =false;
    var infoTmp;
    await FirebaseFirestore.instance.collection('subscribers').doc(
        FirebaseAuth.instance.currentUser.uid).get().then((user) {
      infoTmp = {'name': user['name'],
        'provinciaOrdine': user['provinciaOrdine'],
        'dayBirth': user['dayBirth'],
        'monthBirth': user['monthBirth'],
        'yearBirth': user['yearBirth'],
        'numOrdine': user['numOrdine'],
        'specializzazioni': user['specializzazioni'],
        'topic': user['topic'],
        'profileImgUrl': user['profileImgUrl'], // non è user
        'verified': user['verified'],
        'id': FirebaseAuth.instance.currentUser.uid

      };

    });
    setState(() {
      FeedPage().setInfo(infoTmp);
    });

  }

  _saveNotificationHashtag(id, hashtag) async { //,hashtag){
    var timeTmp = Timestamp.now();
    var time = timeTmp.toDate();
    final f = new DateFormat('dd/MM/yyyy').add_Hms();
    var timestamp = f.format(time);
    await FirebaseFirestore.instance.collection('feed')
        .doc(id).get().then( (value) async =>
            await FirebaseFirestore.instance
                .collection('subscribers')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('notification')
                .doc(FirebaseAuth.instance.currentUser.uid+"_"+timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'))
                .set({
              'name': value.data()['nameProfile'],
              'profileImgUrl': value.data()['profileImgUrl'],
              'id': FirebaseAuth.instance.currentUser.uid,
              'idAutorePost': value.data()['id'],
              'timestamp' : value.data()['timestamp'],
              'idPost': id,
              'hashtag' : hashtag
            })
        );
  }

  void updateYetOpened(message) async{
    await FirebaseFirestore.instance
        .collection('feed')
        .doc(message['data']['title']).update({'yet_opened': true});
  }
  @override
  void initState() {
    super.initState();
    initializeInfo();
    bool yet_opened = false;
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var flag = FirebaseAuth.instance.currentUser.uid == message['data']['id'];
        if(!noNotification && !flag) {
          setState(() {
            newNotification = true;
          });
        }
        else {
          setState(() {
            noNotification = false;
          });

        }
        print(message);
        if(message['data']['type']=='topic') { //notifica di nuovo post associato ad un topic
          var hashtag = message['notification']['body'].substring(
              message['notification']['body'].indexOf(':') + 1,
              message['notification']['body']
                  .toString()
                  .length);
          _saveNotificationHashtag(message['data']['title'], hashtag);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        // optional
          FirebaseFirestore.instance
              .collection('feed')
              .doc(message['data']['title'])
              .get()
              .then((value) {
            if(value['yet_opened']==false) {

              updateYetOpened(message);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OpenNotification(value, 2)));
            }
          });
          if(message['data']['type']=='topic' && FirebaseAuth.instance.currentUser.uid != message['data']['title'].substring(message['data']['title'].indexOf('_')+1, message['data']['title'].indexOf('-'))) { //notifica di nuovo post associato ad un topic
            var hashtag = message['data']['body'].substring(
                message['data']['body'].indexOf(':') + 1,
                message['data']['body']
                    .toString()
                    .length);
            _saveNotificationHashtag(message['data']['title'], hashtag);
          }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        FirebaseFirestore.instance
            .collection('feed')
            .doc(message['data']['title'])
            .get()
            .then((value) {
          if(value['yet_opened']==false) {
            updateYetOpened(message);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpenNotification(value, 2)));
          }
        });

        if(message['data']['type']=='topic' && FirebaseAuth.instance.currentUser.uid != message['data']['title'].substring(message['data']['title'].indexOf('_')+1, message['data']['title'].indexOf('-'))) { //notifica di nuovo post associato ad un topic

          var hashtag = message['data']['body'].substring(
              message['data']['body'].indexOf(':') + 1,
              message['data']['body']
                  .toString()
                  .length);
          _saveNotificationHashtag(message['data']['title'], hashtag);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool verified = false;
    try{
     verified = info['verified'];
    }catch (e){
      print('error');
      Container();
    }
    return Scaffold(

      floatingActionButton: verified ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _newPost();
        }, //new post page
        backgroundColor: Colors.orange,
        splashColor: Colors.yellow,
      ) : Container(),
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

          ),
          title: Center(child: Text('MedBook')),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: _search),

            IconButton(
              icon: newNotification ? Icon(Icons.notification_important_outlined) : Icon(Icons.notifications),
              onPressed: _notification,
            ),
          ],
        ),

      ),
      body: _buildBody(context),
    );
  }

  Widget drawDrawerHeader() {
    return Container(
      height: 90.0,
      child: DrawerHeader(

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
    bool verified = false;
    try{
      verified = info['verified'];
    }catch (e){
      print('error');
      Container();
    }

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
      enabled: verified,
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
    info = null;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    FirebaseAuth.instance.signOut();
  }

  void _notification() {
    setState(() {
      newNotification = false;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Notifications()));

  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
  }


  _newPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostScreen(0)),
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

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),

      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  String profileImageOnPost(String id) {
    String tmp = ' ';
    FirebaseFirestore.instance.collection('subscribers').doc(id).get().then((
        value) =>
    tmp = value['profileImgUrl']);
    return tmp;
  }

  Future<bool> profileImageUrl(Map<String, dynamic> record) async {
    await FirebaseFirestore.instance.collection('subscribers')
        .doc(record['id'])
        .get()
        .then(
            (value) =>
            record.update('profileImgUrl', (value2) => value['profileImgUrl']));
  }

  urlImageProfile(UserMB record) {
    CollectionReference users = FirebaseFirestore.instance.collection(
        'subscribers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(record.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        Map<String, dynamic> data = snapshot.data.data();
        ClipRRect(borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.hardEdge,
          child: Image.network(record.profileImgUrl, height: 50, width: 50),);

      },
    );
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {

    Map<String, dynamic> tmp = data.data();
    profileImageUrl(tmp);

    final record = Record.fromSnapshot(data);

    return PostTile(data, context, 0);

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

  // implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

void _activeNotifications() {}

String _visualizeComments(record) {
  return record.comments.map((data) => data['comment'][0].toString());
}


