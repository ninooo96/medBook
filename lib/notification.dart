import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medbook/openNotification.dart';

import 'feedPage.dart';

class Notifications extends StatefulWidget {
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

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('subscribers')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('notification')
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

  Future<bool> profileImageUrl(Map<String, dynamic> record) async {
    await FirebaseFirestore.instance
        .collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) =>
        record.update('profileImgUrl', (value2) => value['profileImgUrl']));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    Map<String, dynamic> tmp = data.data();
    profileImageUrl(tmp);
    return notificationTile(data, context);
  }

  Widget notificationTile(data, context) {
    var currentID = FirebaseAuth.instance.currentUser.uid;
    var name = data['name'];
    var id = data['id'];
    var idAutorePost = data['idAutorePost'];
    var profileImgUrl = data['profileImgUrl'];
    var hashtag = data['hashtag'];
    var idPost = data['idPost'];

    return Column(children: [
      ListTile(
        leading: profileImgUrl == ' '
            ? Icon(Icons.account_circle_outlined, size: 50)
            : ClipRRect(
            borderRadius: BorderRadius.circular(30),
            clipBehavior: Clip.hardEdge,
            child: Image.network(profileImgUrl, height: 50, width: 50, fit: BoxFit.fitWidth,)),
        title: hashtag == ''
            ? (idAutorePost == currentID && id != idAutorePost)
            ? Text(name + ' ha commentato un tuo post')
            : Text(name + ' ha commentato un post che segui')

            : Text(name + " | ha pubblicato un post con l'hashtag: " + hashtag),
        onTap: () => {openPostTile(idPost)},
      ),
      Divider()
    ]);
  }

  Widget openPostTile(idPost) {
    FirebaseFirestore.instance
        .collection('feed')
        .doc(idPost)
        .get()
        .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenNotification(value, 1)));
  });
  }
}
