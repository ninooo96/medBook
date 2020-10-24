import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medbook/feedPage.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/user.dart';
import 'package:medbook/welcomeScreen.dart';

import 'commentScreen.dart';
import 'newPostScreen.dart';
import 'record.dart';
import 'setting.dart';

// String nameProfile;

class MyProfile extends StatefulWidget {
  // String title ;
  var idProfile;
  var nameProfile;
  UserMB user;

  MyProfile(UserMB user) {
    this.idProfile = user.id;
    this.nameProfile = user.nameProfile;
    this.user = user;
  }
//   String getTitle(){
//     return title;
// }

  @override
  _MyProfileState createState() => _MyProfileState(user);

// nameProfile(){
//   for(var elem in dummySnapshot){
//     if(elem['id'] == id_accesso) {
//       print(elem['nameProfile']);
//       return elem['nameProfile'];
//     }
//     return '404';
//   }
// }
}

class _MyProfileState extends State<MyProfile> {
  var idProfile;
  var nameProfile;
  bool buildedHeader = false;
  UserMB user;

  _MyProfileState(UserMB user) {
    this.idProfile = user.id;
    this.nameProfile = user.nameProfile;
    this.user = user;
  }


  @override
  Widget build(BuildContext context) {
    // var route = ModalRoute.withName('myProfile');
    // print(route.toString());
    // if(route!=null){
    //   print(route.settings.name);
    // }
    return _build(context, nameProfile, idProfile, user);
    // return StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance.collection('subscribers').snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) return LinearProgressIndicator();
    //     print('OK2');
    //     // print(snapshot.data.docs[id_accesso-1]['nameProfile']);
    //     return  _build(context, snapshot.data.docs[id_profile-1]['nameProfile']);
    //   },
    // );
  }

  Widget _build(BuildContext context, String nameProfile, String idProfile,
      UserMB user) {
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
            //
            // leading: IconButton(
            //   icon: Icon(Icons.menu),
            //   onPressed: _openDrawer,
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
            title: Center(child: Text(user.nameProfile)),
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
        // child: Text('Specializzazioni',
        //     textScaleFactor: 1.8,
        //     textAlign: TextAlign.left,
        //     style: TextStyle(color: Colors.white)),
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
    //TODO scollegati da Firebase
    Navigator.of(context).popUntil(ModalRoute.withName('welcome'));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  void _postWithMyHashtags() {
    print("ciao Anto");
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

  ListTile _specializzazioni() {
    print(info['specializzazioni'].toList() == []);
    if (info['specializzazioni'].length == 0) {
      return ListTile(title: Text(' '));
    } else {
      return ListTile(
          dense: true,
          title: Text('Specializzato in: ' +
              user.specializzazioni.toString().substring(
                  1, user.specializzazioni
                  .toString()
                  .length - 1)));
    }
  }

// Widget _buildBodyList(
//     BuildContext context, String nameProfile, String idProfile) {
//   return Column(
//     children: [
//       _buildBodyHeader(),
//       _buildBodyList(context, nameProfile, idProfile)
//     ],
//   );
// }
//   ListTile _specializzazioni() {
//     print(info['specializzazioni'].toList() == []);
//     if (info['specializzazioni'].length == 0) {
//       return ListTile(title: Text(' '));
//     } else {
//       return ListTile(
//           dense: true,
//           title: Text('Specializzato in: ' +
//               info['specializzazioni'].toString().substring(
//                   1, info['specializzazioni'].toString().length - 1)));
//     }
//   }
  Widget _buildBodyHeader(UserMB user) {
    // if (buildedHeader) {
    //   return Container();
    // } else {
    //   buildedHeader = true;
    // print(_controllerImage.value);
    return Container(
        height: 150,
        child: Row(children: [
          user.profileImgUrl != ' '
              ? CircleAvatar(

            radius: 50,
            // child: Image.network(info['profileImgUrl']),
            backgroundImage: NetworkImage(user.profileImgUrl),
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
          ,
          Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  info['provinciaOrdine'] == ' '
                      ? ListTile(
                    dense: true,
                    title: Text(''),
                  )
                      : ListTile(
                      dense: true,
                      title: Text(
                        'Ordine della provincia di \n' +
                            user.provinciaOrdine,
                        textScaleFactor: 1.5,
                      )),
                  (user.dayBirth == ' ' &&
                      user.monthBirth == ' ' &&
                      user.yearBirth == ' ')
                      ? ListTile(dense: true, title: Text(''))
                      : ListTile(
                      dense: true,
                      title: Text(
                        'Data di nascita: ' +
                            user.dayBirth.toString() +
                            '/' +
                            user.monthBirth +
                            '/' +
                            user.yearBirth.toString(),
                      )),
                  _specializzazioni(),
                ],
              ))
        ]));
  }


  // Widget _buildBodyHeader(Record record) {
  //   // if (buildedHeader) {
  //   //   return Container();
  //   // } else {
  //   //   buildedHeader = true;
  //     return Container(
  //         height: 150,
  //         child: ListTile(
  //           leading: record.profileImgUrl==' ' ? Icon(Icons.account_circle_outlined,size: 50) : Container(height: 100, width: 100,child: Image.network(record.profileImgUrl)),
  //           title: info['provinciaOrdine'] == ' '
  //               ? Text('')
  //               : Text(
  //                   'Ordine della provincia di \n' + info['provinciaOrdine']),
  //           subtitle: (info['dayBirth'] == ' ' &&
  //                   info['monthBirth'] == ' ' &&
  //                   info['yearBirth'] == ' ')
  //               ? Text('')
  //               : Text('\nData di nascita: \n' +
  //                   info['dayBirth'].toString() +
  //                   '/' +
  //                   info['monthBirth'] +
  //                   '/' +
  //                   info['yearBirth'].toString() +
  //                   _specializzazioni()),
  //           isThreeLine: true,
  //         ));
  //
  // }

  Widget _buildBody(BuildContext context, String nameProfile,
      String idProfile) {
    //TODO: estrai snapshot dal Cloud Firebase
    // List<Map> snapshot = dummySnapshot;
    // return _buildList(context, snapshot);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        print('OK');
        return _buildList(
            context, snapshot.data.docs, nameProfile, idProfile);
      },
    );
  }

// Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot2) {

// return StreamBuilder<QuerySnapshot>(
//   stream: FirebaseFirestore.instance.collection('subscribers').snapshots(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) return LinearProgressIndicator();
//     print('OK2');
//     // print(snapshot.data.docs[id_accesso-1]['nameProfile']);
//     return  _buildList2(context, snapshot2, snapshot.data.docs[id_profile-1]['nameProfile'], id_profile);
//   },
// );
//   print(FirebaseFirestore.instance.collection("subscribers").get());//doc(id_accesso.toString()).get()[0]());
// return _buildList2(context, snapshot, querySnapshot.data()['nameProfile']);
// }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      String nameProfile, String idProfile) {
    // var snapshot2 = snapshot.where((id) => id==id_accesso);
    // print(snapshot2);
//
    return Expanded(child: ListView(
      padding: const EdgeInsets.only(top: 5.0),
      //da giocarci dopo che visualizzo un post
      //     final record = Record.fromMap(data);
      // // print(record);
      // if( record.id==2){
      //   print(record.post);
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
    // title = nameProfile;
    print('amnnaiaa');
    print(idProfile);
    if (Record
        .fromSnapshot(data)
        .id != idProfile) return Container();
    var record = Record.fromSnapshot(data);

    // if(recordTot.id==id_accesso){
    //   recordTmp = recordTot;
    // }
    // final record = recordTmp;
    print(record);
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
    //             leading: record.profileImgUrl == ' ' ? Icon(
    //                 Icons.account_circle_outlined, size: 50) : ClipRRect(
    //                 borderRadius: BorderRadius.circular(20),
    //                 clipBehavior: Clip.hardEdge,
    //                 child: Image.network(
    //                     record.profileImgUrl, height: 50, width: 50)),
    //             title: Text(record.nameProfile),
    //             subtitle: Text(record.timestamp),
    //             onTap: () {
    //               var snap = FirebaseFirestore.instance.collection(
    //                   'subscribers').doc(record.id).get().then((value) {
    //                 UserMB user = UserMB.fromSnapshot(value);
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) =>
    //                           MyProfile(
    //                               user)), //.nameProfile, record.id.toString())),
    //                 );
    //               });
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
    //                           1, record.hashtags
    //                           .toString()
    //                           .length - 1)) +
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
    //                       addComment(
    //                           context, record.comments, record.reference, 1);
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

// void addComment(context, record, nuovoCommento) { //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
//   print('Ciao Lele' + record.length.toString(), );
//   print(record);
//   if(record.length==0)
//     record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0}];
//   print(record);
//   if(record.length != 1 || nuovoCommento==1) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CommentScreen(record, reference)),
//     );
//   }
//
// }
// void addComment(context, List<dynamic> record1, reference, nuovoCommento) { //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
//   print('Ciao Lele' + record1.length.toString() );
//   List<Map<String,dynamic>> record = new List<Map<String,dynamic>>();// la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
//   record1.forEach((data) => record.add({
//     'nameProfile' : data['nameProfile'],
//     'comment': data['comment'],
//     'upvote': data['upvote'],
//     'downvote' : data['downvote']
//   }));
//   if(record.length==0)
//     record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0}];
//   print(record);
//   if(record.length != 1 || nuovoCommento==1) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CommentScreen(record, reference)),
//     );
//   }
//
// }
//   void addComment(context, List<dynamic> record1, reference, nuovoCommento) {
//     //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
//     // print('Ciao Lele' + record1.length.toString() );
//     List<Map<String, dynamic>> record2 = new List<
//         Map<String,
//             dynamic>>(); // la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
//     // print(nuovoCommento);
//     // print(record1.first.length);
//     if (record1.first.length != 0) {
//       record1.forEach((data) =>
//           record2.add({
//             'nameProfile': data['nameProfile'],
//             'comment': data['comment'],
//             'upvote': data['upvote'],
//             'downvote': data['downvote'],
//             'idVotersLike': data['idVotersLike'],
//             'idVotersDislike': data['idVotersDislike'],
//             'profileImgUrl': data['profileImgUrl']
//           }));
//     }
//
//     // if(record.length==0)
//     //   record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0, 'idVotersLike':[0], 'idVotersDislike':[0]}];
//     // print(record);
//     if (record1.first.length != 0 || nuovoCommento == 1) {
//       // record1 = record;
//       // Navigator.of(context).pop();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CommentScreen(record2, reference)),
//       );
//     }
//   }
}

// class Record {
//   final String nameProfile;
//   final String sexPatient;
//   final String post;
//   final int agePatient;
//   final int numComment;
//   final String id;
//
//   final List comments;
//   final List hashtags;
//
//   final DocumentReference reference;
//
//   Record.fromMap(Map<String, dynamic> map, {this.reference})
//       : nameProfile = map['nameProfile'],
//         sexPatient = map['sexPatient'],
//         agePatient = map['agePatient'],
//         post = map['post'],
//         numComment = map['numComment'],
//         id = map['id'],
//         hashtags = map['hashtags'],
//         comments = map['comments'];
//
//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data(), reference: snapshot.reference);
//
//   String toString() => "Record<$nameProfile:$post>";
// }

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
