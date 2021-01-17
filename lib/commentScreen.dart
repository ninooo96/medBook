import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medbook/record.dart';
import 'package:medbook/user.dart';
import 'package:medbook/utility.dart';

import 'feedPage.dart';
import 'myProfile.dart';
bool verified = FeedPage().getInfo()['verified'];

class Comment extends StatefulWidget implements Comparable {
  var record;
  DocumentReference reference;
  var comment;
  List<Map<String, dynamic>> comments;
  String idPost;

  Comment(idPost, record, comment, reference, comments) {
    this.record = record;
    this.reference = reference;
    this.comments = comments;
    this.idPost = idPost;
    this.comment = comment;
  }

  @override
  _CommentState createState() => _CommentState(idPost, record, comment, reference, comments);

  @override
  int compareTo(other) {
    if (this.comment['upvote'] - this.comment['downvote'] <
        other['upvote'] - other['downvote']) return -1;
    if (this.comment['upvote'] - this.comment['downvote'] >
        other['upvote'] - other['downvote']) return 1;
    if (this.comment['upvote'] - this.comment['downvote'] ==
        other['upvote'] - other['downvote']) return 0;
    return null;
  }
}

class _CommentState extends State<Comment> {
  var record;
  String text;
  int upvote;
  int downvote;
  bool votatoLike;
  bool votatoDislike;
  var comment;
  DocumentReference reference;
  List<Map<String, dynamic>> comments;
  String profileImgUrl;
  String id;
  String idPost;
  bool deleted = false;

  _CommentState(idPost, record, comment, reference, comments) {
    this.text = comment['comment'];
    this.id = comment['id'];
    this.upvote = comment['upvote'];
    this.downvote = comment['downvote'];
    this.comment = comment;

    this.record = record;
    this.reference = reference;
    this.comments = comments;
    this.idPost = idPost;
    this.votatoLike =
        comment['idVotersLike'].contains(FirebaseAuth.instance.currentUser.uid)
            ? true
            : false;
    this.votatoDislike = comment['idVotersDislike']
            .contains(FirebaseAuth.instance.currentUser.uid)
        ? true
        : false;

    FirebaseFirestore.instance.collection('subscribers').doc(id).get().then((
        value) {
      setState(() {
        profileImgUrl = value.data()['profileImgUrl'];
      });

    }


    );
  }

  void handleClick(String value){
    switch(value){
      case 'Elimina commento':
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Sicuro di voler eliminare il commento?"),
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
                          setState(() {
                            comments.remove(comment);
                          });
                          if(comments.isEmpty)
                            reference.update({'comments': [{}]});
                          else {
                            reference.update({'comments': comments});
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            deleted = true;
                          });
                          Utility().removeDeviceToken(reference, comment['nameProfile'], comment['id'], comment['token'], timestamp : comment['timestamp'], listToken: record.listTokens);
                        },
                        child: Text(
                          'Sì',
                          textScaleFactor: 1.5,
                        ))
                  ],
                ),
              );
            });
    }
  }

  @override
  Widget build(BuildContext context) {

    return deleted ? Container() : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: profileImgUrl == ' ' || profileImgUrl == null
                  ? Icon(Icons.account_circle_outlined, size: 50)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      clipBehavior: Clip.hardEdge,
                      child:
                          Image.network(profileImgUrl, height: 50, width: 50, fit: BoxFit.fitWidth)),

              trailing: PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Elimina commento'}
                        .map((String choice) {
                      return PopupMenuItem<String>(

                          enabled: id == FirebaseAuth.instance.currentUser.uid || idPost==FirebaseAuth.instance.currentUser.uid, //se sono l'autore del post o l'autore del commento

                          value: choice, child: Text(choice));
                    }).toList();
                  }),
              title: Text(
                comment['nameProfile'],
                textScaleFactor: 1.2,
              ),
              onTap: () {
                FirebaseFirestore.instance.collection('subscribers').doc(comment['id']).get().then((value) {
                  UserMB user = UserMB.fromSnapshot(value);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyProfile(user))
                  );
                });


              },
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(text),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                        child: IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: verified ? votatoLike ? Colors.green : Colors.grey : null,
                      onPressed: !verified ? null : () {
                        setState(() {
                          if (!votatoLike && !votatoDislike) {
                            upvote++;
                            comments.remove(comment);
                            comment['upvote'] = upvote;
                            comment['idVotersLike']
                                .add(FirebaseAuth.instance.currentUser.uid);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            votatoLike = true;
                          } else if (votatoLike && !votatoDislike) {
                            upvote--;
                            comments.remove(comment);
                            comment['upvote'] = upvote;
                            comment['idVotersLike']
                                .remove(FirebaseAuth.instance.currentUser.uid);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            votatoLike = false;
                          }
                        });
                      },
                    )),
                    Flexible(
                      child: Text((upvote - downvote).toString()),
                    ),
                    Flexible(
                        child: IconButton(
                      color: verified ? votatoDislike ? Colors.red : Colors.grey : null,
                      icon: Icon(Icons.thumb_down),

                      onPressed: !verified ? null : () {
                        setState(() {
                          if (!votatoDislike && !votatoLike) {
                            downvote++;
                            comments.remove(comment);
                            comment['downvote'] = downvote;
                            comment['idVotersDislike']
                                .add(FirebaseAuth.instance.currentUser.uid);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            votatoDislike = true;
                          } else if (votatoDislike && !votatoLike) {
                            downvote--;
                            comments.remove(comment);
                            comment['downvote'] = downvote;
                            comment['idVotersDislike']
                                .remove(FirebaseAuth.instance.currentUser.uid);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            votatoDislike = false;
                          }
                        });
                      },
                    )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );

  }


}


class CommentScreen extends StatefulWidget {
  List<Map<String, dynamic>> comments;

  DocumentReference reference;
  String idPost;
  Record record;
  int route;

  CommentScreen(record, comments, reference, int route) {
    this.comments = comments;
    this.reference = reference;
    this.idPost = record.id;
    this.record = record;
    this.route = route;
  }

  @override
  _CommentScreenState createState() => _CommentScreenState(record, comments, reference, route);
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> _comments = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DocumentReference reference;
  String idPost;
  int route;
  Record record;
  List<Map<String,dynamic>> listTokens  = new List<
      Map<String,
          dynamic>>();

  List<Map<String, dynamic>> comments;

  void setComments(List<Comment> newComments) {
    this._comments = newComments;
  }


  _CommentScreenState(record, comments, reference, route) {
    this.comments = comments;
    this.reference = reference;
    this.idPost = record.id;
    this.record=record;
    this.route = route;

    for (var data in comments) {
      if (data['nameProfile'] != '')
        _comments.add(Comment(idPost, record, data, reference, comments));
    }
    _comments.sort((a, b) {
      return a.compareTo(b.comment);
    });
  }

  void populateTokens(){
    var tmp = record.listTokens;
    listTokens  = new List<
        Map<String,
            dynamic>>();
    tmp.forEach((element) {
      listTokens.add({
        'name': element['name'],
        'token' : element['token'],
        'id' : element['id']

      }
      );
    });
}


    @override
    Widget build(BuildContext context) {
    populateTokens();

      return Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffbb448), Color(0xfff7892b)])),

            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:() {
                if(route == 0)
                  Navigator.pushReplacement( context, MaterialPageRoute(builder: (BuildContext context) => MyFeedPage()));
                else if(route ==1){
                  FirebaseFirestore.instance
                      .collection('subscribers')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get()
                      .then((value) =>
                  Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (BuildContext context) => MyProfile(UserMB.fromSnapshot(value)))));
                  }
                else{
                  Navigator.of(context).pop();
                }
                }
            ),
            title: Text('Commenti')),
            body: Column(
            children: [
            Flexible(
            child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _comments[index],
            itemCount: _comments.length

              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme
                  .of(context)
                  .cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      );
    }

    Widget _buildTextComposer() {
      return IconTheme(
        data: IconThemeData(color: Colors.orange),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  enabled: FeedPage().getInfo()['verified'],
                  controller: _textController,
                  onSubmitted: _handleSubmitted_tmp,
                  decoration:
                  InputDecoration.collapsed(hintText: 'Invia un commento'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted_tmp(comments)),
              )
            ],
          ),
        ),
      );
    }

    void _handleSubmitted_tmp(comment) {
      FirebaseFirestore.instance
          .collection('subscribers')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) => _handleSubmitted(comment, value['name']));
    }

    //post comment
    Future<void> _handleSubmitted(comment, nameProfile) async {
      var timeTmp = Timestamp.now();
      var time = timeTmp.toDate();
      final f = new DateFormat('dd/MM/yyyy').add_Hms();
      var timestamp = f.format(time);

      if (_textController.text == '') return;
      var newEntry = {
        'nameProfile': nameProfile,
        'comment': _textController.text,
        'upvote': 0,
        'downvote': 0,
        'idVotersLike': [],
        'idVotersDislike': [],
        'profileImgUrl': info['profileImgUrl'],
        'id': FirebaseAuth.instance.currentUser.uid,
        'token' : await FeedPage().getFCM().getToken(),
        'timestamp' :timestamp.toString().replaceAll('/', '').replaceAll(' ', '-')
      };

      comments.add(newEntry);
      reference.update({'comments': comment});
      Utility().saveDeviceToken(reference, nameProfile, FirebaseAuth.instance.currentUser.uid.toString(), timestamp: timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'));
      setState(() {
        _comments.add(Comment(idPost, record, newEntry, reference, comments));
      });

      //save to notification


      for (var map in record.listTokens){
        if(map['id']!=FirebaseAuth.instance.currentUser.uid) {
          await FirebaseFirestore.instance
              .collection('subscribers')
              .doc(map['id'])
              .collection('notification')
              .doc(record.id + "_" +
              timestamp.toString().replaceAll('/', '').replaceAll(' ', '-'))
              .set({
            'name': nameProfile,
            'profileImgUrl': info['profileImgUrl'],
            'id': FirebaseAuth.instance.currentUser.uid,
            'idAutorePost': record.id,
            'timestamp': timeTmp,
            'hashtag' : '',
            'idPost' : record.nameProfile.toString().toLowerCase().replaceAll(' ', '') +
                "_" +
                record.id +
                "-" +
                record.timestamp.toString().replaceAll('/', '').replaceAll(' ', '-')
          });
        }
      }


      _textController.clear();
    }

}
