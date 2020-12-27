import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feedPage.dart';

class Notifications extends StatefulWidget{
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffbb448), Color(0xfff7892b)])),
            ),
            title: Text('Notifiche'),
          )),
      body: _buildBody(context),
    );
  }
  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('subscribers')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('notification')
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
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),

    );
  }

  Future<bool> profileImageUrl(Map<String, dynamic> record) async {
    // print(record['id']);
    await FirebaseFirestore.instance.collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then(
            (value) =>
            record.update('profileImgUrl', (value2) => value['profileImgUrl']));
    // print(record['profileImgUrl']+' PROVAAAA');


  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    Map<String, dynamic> tmp = data.data();
    profileImageUrl(tmp);
    return notificationTile(data, context);
  }


Widget notificationTile(data, context) {
  // var data;
  // var context;

  // NotificationTile(data, context){
  //   this.data = data;
  //   this.context = context;
  // }
  var currentID = FirebaseAuth.instance.currentUser.uid;
  var name = data['name'];
  var id = data['id'];
  var idAutorePost = data['idAutorePost'];
  var profileImgUrl = data['profileImgUrl'];
  // var idPost = data['idPost']; //GIUSTO MA DA ELIMINARE LE VECCHIE NOTIFICHE
  print('ciao');
  print(currentID);
  print(idAutorePost);
  print(id);
  print('ciao');

  return Column(children: [
    ListTile(
    leading: profileImgUrl == ' ' ? Icon(
        Icons.account_circle_outlined, size: 50) : ClipRRect(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: Image.network(
            profileImgUrl, height: 50, width: 50)),
    title: (idAutorePost == currentID && id != idAutorePost) ? Text(
        name + ' ha commentato un tuo post') :
    (idAutorePost != currentID && id != idAutorePost) ? Text(
        name + ' ha commentato un post che segui') :
    Text(''),

  ),
  Divider()
  ]);
}
}

