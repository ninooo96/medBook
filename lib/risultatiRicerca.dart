import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/record.dart';

class RisultatiRicerca extends StatefulWidget {
  String nameRicerca;
  String hashtag;

  RisultatiRicerca(String nameRicerca, String hashtag) {
    this.nameRicerca = nameRicerca;
    this.hashtag = hashtag;
  }

  @override
  _RisultatiRicercaState createState() =>
      _RisultatiRicercaState(nameRicerca, hashtag);
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
      body: _buildBody(context),
    );
  }

  titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      // Assign it back to the array
      splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join('').toString();
  }

  Widget _buildBody(BuildContext context) {
    var stream = FirebaseFirestore.instance.collection('feed');
    if (nameRicerca != '' && hashtag != '') {
      var nameRicerca2 = titleCase(nameRicerca);
      var tmp = titleCase(hashtag);
      var hashtag2 = tmp.replaceAll('.', '');
      List<String> hashtagList =
          hashtag2.contains(',') ? hashtag2.split(",") : [hashtag2];
      if (nameRicerca2.split(' ').length == 1) {
        return StreamBuilder<QuerySnapshot>(
          stream: stream
              .where('name', isEqualTo: nameRicerca2)
              .where('hashtags', arrayContainsAny: hashtagList)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            if (snapshot.data.docs.length != 0)
              return _buildList(context, snapshot.data.docs);
            else {
              return StreamBuilder<QuerySnapshot>(
                  stream: stream
                      .where('surname', isEqualTo: nameRicerca2)
                      .where('hashtags', arrayContainsAny: hashtagList)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return _buildList(context, snapshot.data.docs);
                  });
            }
          },
        );
      } else {
        return StreamBuilder<QuerySnapshot>(
            stream: stream
                .where('nameProfile', isEqualTo: nameRicerca2)
                .where('hashtags', arrayContainsAny: hashtagList)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.docs);
            });
      }
    } else if (nameRicerca != '') {
      var nameRicerca2 = titleCase(nameRicerca);
      if (nameRicerca2.split(' ').length == 1) {
        return StreamBuilder<QuerySnapshot>(
          stream: stream
              .where('name', isEqualTo: nameRicerca2)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            if (snapshot.data.docs.length != 0)
              return _buildList(context, snapshot.data.docs);
            else {
              return StreamBuilder<QuerySnapshot>(
                  stream: stream
                      .where('surname', isEqualTo: nameRicerca2)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return _buildList(context, snapshot.data.docs);
                  });
            }
          },
        );
      } else {
        return StreamBuilder<QuerySnapshot>(
            stream: stream
                .where('nameProfile', isEqualTo: nameRicerca2)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.docs);
            });
      }
    } else if (hashtag != '') {
      var tmp = titleCase(hashtag);
      var hashtag2 = tmp.replaceAll('.', '');
      List<String> hashtagList =
          hashtag2.contains(',') ? hashtag2.split(",") : [hashtag2];

      return StreamBuilder<QuerySnapshot>(
        stream:
        stream
            .where('hashtags', arrayContainsAny : hashtagList)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.docs);
        },
      );
    }
  }

  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, QueryDocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return PostTile(data, context,3);
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
