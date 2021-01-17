import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medbook/feedPage.dart';
import 'package:medbook/notification.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/search.dart';
import 'package:medbook/user.dart';
import 'package:medbook/welcomeScreen.dart';

import 'commentScreen.dart';
import 'newPostScreen.dart';
import 'record.dart';
import 'setting.dart';

class MyProfile extends StatefulWidget {
  var idProfile;
  var nameProfile;
  UserMB user;

  MyProfile(UserMB user) {
    this.idProfile = user.id;
    this.nameProfile = user.nameProfile;
    this.user = user;
  }

  @override
  _MyProfileState createState() => _MyProfileState(user);

}

class _MyProfileState extends State<MyProfile> {
  var idProfile;
  var nameProfile;
  bool buildedHeader = false;
  UserMB user;
  bool newNotification = false;

  _MyProfileState(UserMB user) {
    this.idProfile = user.id;
    this.nameProfile = user.nameProfile;
    this.user = user;
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

  @override
  void initState() {
    super.initState();
    FeedPage().getFCM().configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          var flag = FirebaseAuth.instance.currentUser.uid ==
              message['data']['id'];
          if (!noNotification && !flag) {
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
          if (!message['data']['title'].contains('commentato') &&
              FirebaseAuth.instance.currentUser.uid !=
                  message['data']['title'].substring(
                      message['data']['title'].indexOf('_') + 1,
                      message['data']['title'].indexOf(
                          '-'))) { //notifica di nuovo post associato ad un topic
            var hashtag = message['notification']['body'].substring(
                message['notification']['body'].indexOf(':') + 1,
                message['notification']['body']
                    .toString()
                    .length);
            _saveNotificationHashtag(message['data']['title'], hashtag);
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('onlaunch profile');
        },
        onResume: (Map<String, dynamic> message) async {
          print('onresumen profile');
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return _build(context, nameProfile, idProfile, user);
  }

  Widget _build(BuildContext context, String nameProfile, String idProfile,
      UserMB user) {
    return Scaffold(
        floatingActionButton:FeedPage().getInfo()['verified'] ? FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _newPost();
          }, //new post page
          backgroundColor: Colors.orange,
          splashColor: Colors.yellow,
        ) : null,
        drawer: Drawer(
            child: Column(
              children: <Widget>[
                drawDrawerHeader(),
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: _drawerTile(nameProfile, idProfile)),
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
            title: Center(child: Text(user.nameProfile)),
            actions: [
              IconButton(icon: Icon(Icons.search), onPressed: _search),
              IconButton(
                icon: newNotification ? Icon(Icons.notification_important_outlined) : Icon(Icons.notifications),
                onPressed: _notification,
              ),
            ],
          ),

        ),
        body: Column(children: [
          _buildBodyHeader(user),
          _buildBody(context, nameProfile, idProfile),
        ])
    );
  }

  Widget drawDrawerHeader() {
    return Container(
      height: 90.0,
      child: DrawerHeader(

          decoration: BoxDecoration(color: Colors.orange),
          padding: EdgeInsets.symmetric(vertical: 25)),
    );
  }

  _drawerTile(String nameProfile, String idProfile) {
    List<Widget> drawerTile = [];
    drawerTile.add(ListTile(
      title: Text(
        'Home',
        textScaleFactor: 1.5,
      ),
      onTap: () {
        Navigator.of(context).pop();
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
      enabled: FeedPage().getInfo()['verified'],
      title: Text(
        'Il mio profilo',
        textScaleFactor: 1.5,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyProfile(user)),
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
    //scollegati da Firebase
    Navigator.of(context).popUntil(ModalRoute.withName('welcome'));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
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
      MaterialPageRoute(builder: (context) => NewPostScreen(1)),
    );
  }

  String _specializzazioni() {
    if (user.specializzazioni.length == 0) {
      return '';
    } else {
      return
        'Specializzato in: ' +
            user.specializzazioni.toString().substring(
                1, user.specializzazioni.toString().length - 1);
    }
  }

  Widget _buildBodyHeader(UserMB user) {
    return SingleChildScrollView(child: Container(
        height: 150,
        child: Row(children: [
          user.profileImgUrl != ' '
              ? Padding(padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(

            radius: 50,

            backgroundImage: NetworkImage(user.profileImgUrl),
          ))
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
          ,

          Expanded(child:
          ListTile(dense: true,
              title:
              user.provinciaOrdine == ' ' ? Text('') :
              Text(
                'Ordine della provincia di \n' +
                    user.provinciaOrdine,
                textScaleFactor: 1.5,
              ),
              subtitle:
              (user.dayBirth == ' ' &&
                  user.monthBirth == ' ' &&
                  user.yearBirth == ' ') ? Text('')

                  :
              Text(
                '\nData di nascita: ' +
                    user.dayBirth.toString() +
                    '/' +
                    user.monthBirth.trim() +
                    '/' +
                    user.yearBirth.toString() +'\n\n'+

                    _specializzazioni(),textScaleFactor: 1.2,)))
        ],

        )
    ));
  }




  Widget _buildBody(BuildContext context, String nameProfile,
      String idProfile) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(
            context, snapshot.data.docs, nameProfile, idProfile);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      String nameProfile, String idProfile) {
    return Expanded(child: ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshot
          .map((data) =>
          _buildListItem(
              context, data, nameProfile, idProfile))
          .toList(),
    ));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data,
      String nameProfile, String idProfile) {
    var recordTmp;
    if (Record
        .fromSnapshot(data)
        .id != idProfile) return Container();
    var record = Record.fromSnapshot(data);
    return PostTile(data, context, 1);

  }


  void _notification() {
    setState(() {
      newNotification = false;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Notifications()));

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

  //implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

void _activeNotifications() {}

String _visualizeComments(record) {
  print(record.comments.map((data) => data['comment'].toString()));
  return record.comments.map((data) => data['comment'][0].toString());
}
