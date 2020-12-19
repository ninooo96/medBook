import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medbook/commentScreen.dart';
import 'package:medbook/record.dart';
import 'package:medbook/user.dart';
import 'package:medbook/utility.dart';

import 'feedPage.dart';
import 'myProfile.dart';

// final dummySnapshot = [
//   {'nameProfile': 'Antonio Gagliostro', 'agePatient': 67, 'sexPatient': 'Male', 'post':'Diagnosi1'},
//   {'nameProfile':'Chiara Del Re', 'agePatient':79, 'sexPatient':'Female','post':'Diagnosi2'}
// ];
//
// class PostTile extends StatefulWidget {
//   Record record;
//   DocumentSnapshot data;
//   PostTile(Record record, DocumentSnapshot data){
//     this.record = record;
//     this.data = data;
//   }
//
//   @override
//   _PostTileState createState() => _PostTileState(record, data);
//
// }
//
// class _PostTileState extends State<PostTile> {
//   Record record;
//   String urlImgProfile;
//   int numCommenti;
//   // DocumentReference reference;
//   DocumentSnapshot data;
//
//   _PostTileState(Record record, DocumentSnapshot data){
//     this.record = record;
//     this.numCommenti = record.comments.length;
//     this.data = data;
//   }
//

//
//   @override
//   Widget build(BuildContext context) {
class PostTile extends StatefulWidget {
  var data;
  var context;
  int route;

  PostTile(data, context, route) {
    this.data = data;
    this.context = context;
    this.route = route;
  }

  @override
  _PostTileState createState() => _PostTileState(data, context, route);
}

class _PostTileState extends State<PostTile> {
  var data;
  var context;
  var record;
  var _fcm;
  var containToken = false;
  bool eliminato = false;
  int route;

  _PostTileState(data, context, route) {
    this.data = data;
    this.context = context;
    this.record = Record.fromSnapshot(data);
    this._fcm = MyFeedPage().getFCM();
    this.route = route;
    // _containToken();
  }
  @override
  void initState() {
    super.initState();
    // _containToken();
    _fcm.getToken().then((token){
      for (var map in record.listTokens) {
        if (map.containsValue(token)) {
          setState(() {
            containToken = true;
          });

          return;
        }
        containToken = false;
      }
    });
  }

  _urlProfileImage() {
    FirebaseFirestore.instance.collection('subscribers')
        .doc(record.id).get().then((user) {
      record.reference.update({'profileImgUrl': user['profileImgUrl']});
      // urlImgProfile = user['profileImgUrl'];


    });
  }

  void addComment(context, Record record, nuovoCommento) {
    //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
    // print('Ciao Lele' + record1.length.toString() );
    List<Map<String, dynamic>> record2 = new List<
        Map<String,
            dynamic>>(); // la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
    // print(nuovoCommento);
    // print(record1.first.length);.comments, record.reference
    if (record.comments.first.length != 0) {
      record.comments.forEach((data) =>
          record2.add({
            'nameProfile': data['nameProfile'],
            'comment': data['comment'],
            'upvote': data['upvote'],
            'downvote': data['downvote'],
            'idVotersLike': data['idVotersLike'],
            'idVotersDislike': data['idVotersDislike'],
            'profileImgUrl': data['profileImgUrl'],
            'id': data['id']
          }));
    }

    // if(record.length==0)
    //   record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0, 'idVotersLike':[0], 'idVotersDislike':[0]}];
    // print(record);
    if (record.comments.first.length != 0 || nuovoCommento == 1) {
      // record1 = record;
      // Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CommentScreen(record, record2, record.reference, route)),
      );
    }
  }

  _activateNotifications() async {
    String fcmToken = await _fcm.getToken();
    if (!containToken) {
      Utility().saveDeviceToken(record.reference, info['name'], segui: true);
      print(record.listTokens);
      print(record.nameProfile);
      print(record.reference);
      setState(() {
        containToken = true;
      });

      record.listTokens.add({ 'name': info['name'], 'token': fcmToken});
      //record.listTokens.contains({'token': _fcm.getToken(),      'name': record.nameProfile,});
      print(containToken);
    }
    else {
      Utility().removeDeviceToken(record.reference, info['name'], segui:true);
      setState(() {
        containToken = false;
      });
      for(var map in record.listTokens){
        if(map.containsValue(fcmToken)){
          record.listTokens.remove(map);
          break;
        }
      }
      // record.listTokens.remove({'name': info['name'], 'token': fcmToken,});
    }
  }

  handleClick(String value) {
    switch (value) {
      case 'Elimina post':
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
                          // DateTime date = record.t
                          // print(record.timestamp.replaceAll('/', '').replaceAll(' ', '-'));
                          print(record.nameProfile.toLowerCase().replaceAll(
                              ' ', '') + '_' +
                              FirebaseAuth.instance.currentUser.uid + '-' +
                              record.timestamp.replaceAll('/', '').replaceAll(
                                  ' ', '-'));
                          Navigator.of(context).pop();
                          FirebaseFirestore.instance.collection('feed')
                              .doc(record.nameProfile.toLowerCase().replaceAll(
                              ' ', '') + '_' + FirebaseAuth.instance.currentUser
                              .uid + '-' + record.timestamp.replaceAll('/', '')
                              .replaceAll(' ', '-'))
                              .delete().then((value) {
                                print("Post eliminato");
                                setState(() {
                                  eliminato = true;
                                });
                                })
                            .catchError(
                          (error) =>
                              print("Failed to delete post: $error"));
                          // print(ModalRoute.of(context).settings.name);

                        },
                        child: Text(
                          'Sì',
                          textScaleFactor: 1.5,
                        ))
                  ],
                ),
              );
            });


    // Navigator.of(context).popUntil(ModalRoute.withName('feed'));
    //  Navigator.push(
    //      context, MaterialPageRoute(builder: (context) => FeedPage()));


    }
  }

  // print(urlImgProfile);
  // _containToken()  async {
  //   var token = await _fcm.getToken();
  //   for (var map in record.listTokens) {
  //     if (map.containsValue(token)) {
  //       containToken = true;
  //       return;
  //     }
  //     containToken = false;
  //   }
  //   // containToken = record.listTokens.contains({
  //   //   'name': record.nameProfile,
  //   //   'token': token}.);
  // }


  @override
  Widget build(BuildContext context) {
    _urlProfileImage();
    // setState(() {
    // _containToken();
    // });

    return builder(context);
  }
  Widget builder(BuildContext context){

    // print(containToken);
    // print(record.listTokens);
    return eliminato ? Container() : Padding(
      // key: ValueKey(record.nameProfile),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(children: <Widget>[
              ListTile(
                leading: record.profileImgUrl == ' ' ? Icon(
                    Icons.account_circle_outlined, size: 50) : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                        record.profileImgUrl, height: 50, width: 50)),
                title: Text(record.nameProfile),
                trailing: PopupMenuButton<String>(
                  // enabled: record.id == FirebaseAuth.instance.currentUser.uid,
                    onSelected: handleClick,
                    itemBuilder: (BuildContext context) {
                      return {'Elimina post'}
                          .map((String choice) {
                        return PopupMenuItem<String>(
                            enabled: record.id == FirebaseAuth.instance
                                .currentUser.uid,

                            value: choice, child: Text(choice));
                      }).toList();
                    }),
                //   icon: Icon(Icons.more_vert),
                // ),
                subtitle: Text(
                    record.timestamp.substring(0, record.timestamp.length - 3)),
                onTap: () {
                  FirebaseFirestore.instance.collection('subscribers').doc(
                      record.id).get().then((value) {
                    UserMB user = UserMB.fromSnapshot(value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyProfile(
                                  user)), //.nameProfile, record.id.toString())),
                    );
                  });
                },
              ),
              ListTile(
                  title: Text('Età: ' +
                      (record.agePatient).toString() +
                      (record.sexPatient == 'null'
                          ? ''
                          : (', Sesso: ' + (record.sexPatient))) +
                      (record.hashtags.length == 0
                          ? ''
                          : "\n# " +
                          record.hashtags.toString().substring(
                              1, record.hashtags
                              .toString()
                              .length - 1)) +
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
                  setState(() {
                    addComment(context, record, 0);
                    print(record.comments);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: ListTile(
                        onTap: () {
                          addComment(context, record, 1);
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
                          onTap:
                          _activateNotifications,


                          title: Center(child: Text('Segui',
                            style: containToken
                                ? TextStyle(color: Colors.green)
                                : TextStyle(),
                          ))))
                ],
              )
            ])));
  }

}


deletePost(Record record) {
  FirebaseFirestore.instance.collection('feed')
      .doc(record.nameProfile.toLowerCase().trim() +
      FirebaseAuth.instance.currentUser.uid + record.timestamp)
      .delete().then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}




