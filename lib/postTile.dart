import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medbook/commentScreen.dart';
import 'package:medbook/record.dart';
import 'package:medbook/user.dart';

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
  _urlProfileImage(record){
    FirebaseFirestore.instance.collection('subscribers')
        .doc(record.id).get().then((user) {
          record.reference.update({'profileImgUrl': user['profileImgUrl']});
            // urlImgProfile = user['profileImgUrl'];



    });
  }
//
//   @override
//   Widget build(BuildContext context) {
Widget PostTile(data, context){

    // print(urlImgProfile);
    final record = Record.fromSnapshot(data);
    _urlProfileImage(record);
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
                leading: record.profileImgUrl==' ' ? Icon(Icons.account_circle_outlined,size: 50) : ClipRRect(borderRadius: BorderRadius.circular(20),clipBehavior: Clip.hardEdge, child: Image.network(record.profileImgUrl, height: 50, width:50)),
                title: Text(record.nameProfile),
                subtitle: Text(record.timestamp),
                onTap: () {
                  var snap = FirebaseFirestore.instance.collection('subscribers').doc(record.id).get().then((value) {
                    UserMB user = UserMB.fromSnapshot(value);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfile(user)),//.nameProfile, record.id.toString())),
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

                  // setState(() {
                    addComment(context, record.comments, record.reference, 0);
                    print(record.comments);
                  // });
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
                          // onTap: _activeNotifications,
                          title: Center(child: Text('Segui'))))
                ],
              )
            ])));
  }

  void addComment(context, List<dynamic> record1, reference, nuovoCommento) {
    //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
    // print('Ciao Lele' + record1.length.toString() );
    List<Map<String, dynamic>> record2 = new List<
        Map<String,
            dynamic>>(); // la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
    // print(nuovoCommento);
    // print(record1.first.length);
    if (record1.first.length != 0) {
      record1.forEach((data) =>
          record2.add({
            'nameProfile': data['nameProfile'],
            'comment': data['comment'],
            'upvote': data['upvote'],
            'downvote': data['downvote'],
            'idVotersLike': data['idVotersLike'],
            'idVotersDislike': data['idVotersDislike'],
            'profileImgUrl': data['profileImgUrl']
          }));
    }

    // if(record.length==0)
    //   record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0, 'idVotersLike':[0], 'idVotersDislike':[0]}];
    // print(record);
    if (record1.first.length != 0 || nuovoCommento == 1) {
      // record1 = record;
      // Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentScreen(record2, reference)),
      );
    }
  }
