import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medbook/record.dart';
import 'package:medbook/user.dart';

import 'feedPage.dart';
import 'myProfile.dart';

// final dummySnapshot = [
//   {'nameProfile': 'Antonio Gagliostro', 'agePatient': 67, 'sexPatient': 'Male', 'post':'Diagnosi1'},
//   {'nameProfile':'Chiara Del Re', 'agePatient':79, 'sexPatient':'Female','post':'Diagnosi2'}
// ];

class PostTile extends StatefulWidget {
  Record record;
  PostTile(Record record){
    this.record = record;
  }

  @override
  _PostTileState createState() => _PostTileState(record);

}

class _PostTileState extends State<PostTile> {
  Record record;
  String urlImgProfile;
  int numCommenti;
  // DocumentReference reference;

  _PostTileState(Record record){
    this.record = record;
    this.numCommenti = record.comments.length;
  }

  _urlProfileImage(){
    FirebaseFirestore.instance.collection('subscribers')
        .doc(record.id).get().then((user) {
          record.reference.update({'profileImgUrl': user['profileImgUrl']});
            // urlImgProfile = user['profileImgUrl'];



    });
  }

  @override
  Widget build(BuildContext context) {

    _urlProfileImage();
    print(urlImgProfile);
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
                    ? Text(numCommenti.toString() + ' commenti')
                    : Text(numCommenti.toString() + ' commento')
                    : Text('Non ci sono commenti'),
                onTap: () {

                  addComment(context, record.comments, record.reference, 0);
                  setState(() {
                    numCommenti = record.comments.length;
                  });
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
}
