import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/record.dart';

class RisultatiRicerca extends StatefulWidget {
  String nameRicerca;
  String hashtag;
  RisultatiRicerca(String nameRicerca, String hashtag){
    this.nameRicerca = nameRicerca;
    this.hashtag = hashtag;
  }
  @override
  _RisultatiRicercaState createState() => _RisultatiRicercaState(nameRicerca, hashtag);
}

class _RisultatiRicercaState extends State<RisultatiRicerca> {
  String nameRicerca;
  String hashtag;

  _RisultatiRicercaState(String nameRicerca, String hashtag) {
    this.nameRicerca = nameRicerca;
    this.hashtag = hashtag;
  }

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
            title: Text('Risultati ricerca'),
          )),
      body: _buildBody(context),);
  }

  titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      // You do not need to check if i is larger than splitStr length, as your for does that for you
      // Assign it back to the array
      splitStr[i] =
          splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join(' ').toString();
  }

  Widget _buildBody(BuildContext context) {
    var stream = FirebaseFirestore.instance
        .collection('user');
    if (nameRicerca != '' && hashtag != '') {
      var nameRicerca2 = titleCase(nameRicerca);
      var hashtag2 = hashtag.replaceAll('.', '');
      List<String> hashtagList = hashtag2.contains(',') ?
      hashtag.split(",") : [hashtag];
      return StreamBuilder<QuerySnapshot>(
        stream: stream.where('nameProfile', isEqualTo: nameRicerca2)
            .where('hashtags', arrayContainsAny: hashtagList)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          print(snapshot.data.docs);
          return _buildList(context, snapshot.data.docs);
        },
      );
    }

    else if(nameRicerca!=''){
      var nameRicerca2 = titleCase(nameRicerca);
      List<String> hashtagList = hashtag.contains(',') ?
      hashtag.split(",") : [hashtag];
      return StreamBuilder<QuerySnapshot>(
        stream: stream.where('nameProfile', isEqualTo: nameRicerca2)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          print(snapshot.data.docs);
          return _buildList(context, snapshot.data.docs);
        },
      );
    }

    else if(hashtag!=''){
      var hashtag2 = hashtag.replaceAll('.', '');
      List<String> hashtagList = hashtag2.contains(',') ?
      hashtag.split(",") : [hashtag];
      return StreamBuilder<QuerySnapshot>(
        stream: stream
            .where('hashtags', arrayContainsAny: hashtagList)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          print(snapshot.data.docs);
          return _buildList(context, snapshot.data.docs);
        },
      );
    }
  }

  Widget _buildList(BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      //da giocarci dopo che visualizzo un post

      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  _buildListItem(BuildContext context, QueryDocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    print(record);
    return PostTile( data, context);
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


