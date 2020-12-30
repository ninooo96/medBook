import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medbook/record.dart';
import 'package:medbook/user.dart';
import 'package:medbook/utility.dart';

import 'feedPage.dart';
import 'myProfile.dart';
bool verified = FeedPage().getInfo()['verified'];

class Comment extends StatefulWidget implements Comparable {
  var record; //=[{'nameProfile':'','comment':'','upvote':'0','downvote':0}];
  DocumentReference reference;
  var comment;
  List<Map<String, dynamic>> comments;
  String idPost;
  // List<Comment> _comments;

  // Record record;
  Comment(idPost, record, comment, reference, comments) {
    this.record = record;
    this.reference = reference;
    this.comments = comments;
    this.idPost = idPost;
    this.comment = comment;
    // this._comments = _comments;
    // else
    //   this.record =[{'comments':[{'nameProfile':'','comment':'','upvote':0,'downvote':0}]}];
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
  // List<Comment> _comments;

  _CommentState(idPost, record, comment, reference, comments) {
    this.text = comment['comment'];
    this.id = comment['id'];
    this.upvote = comment['upvote'];
    this.downvote = comment['downvote'];
    this.comment = comment;

    this.record = record;
    // print('quale record?');
    // print(record);
    this.reference = reference;
    // this._comments = _comments;
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
      // print('ora');
      // print(value.data()['profileImgUrl']);
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
                          // Navigator.of(context).pop();
                          // print(record);
                          setState(() {
                            comments.remove(comment);
                          });
                            // List<Comment> _comments2 = [];
                            // for (var data in comments) {
                            //   if (data['nameProfile'] != '')
                            //     _comments2.add(Comment(idPost, data, reference, comments));
                            // }
                            // _comments2.sort((a, b) {
                            //   a.compareTo(b.record);
                            // });
                            // _comments =_comments2;
                          // });
                          if(comments.isEmpty)
                            reference.update({'comments': [{}]});
                          else {
                            // print(comments);
                            reference.update({'comments': comments});
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            deleted = true;
                          });
                          print(info);
                          print(record.listTokens);
                          Utility().removeDeviceToken(reference, comment['nameProfile'], comment['id'], comment['token'], timestamp : comment['timestamp'], listToken: record.listTokens);
                          // Navigator.of(context).reassemble();
                          // print(Navigator.of(context).canPop());
                          // if(Navigator.of(context).canPop() ) {


                          // }
                            // Navigator.of(context).pop();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CommentScreen(idPost, comments, reference)),//.nameProfile, record.id.toString())),
                            // );
              //
              // });
                          // // DateTime date = record.t
                          // // print(record.timestamp.replaceAll('/', '').replaceAll(' ', '-'));
                          // print(record.nameProfile.toLowerCase().replaceAll(' ', '')+'_'+FirebaseAuth.instance.currentUser.uid+'-'+record.timestamp.replaceAll('/', '').replaceAll(' ', '-'));
                          // Navigator.of(context).pop();
                          // FirebaseFirestore.instance.collection('feed')
                          //     .doc(record.nameProfile.toLowerCase().replaceAll(' ', '')+'_'+FirebaseAuth.instance.currentUser.uid+'-'+record.timestamp.replaceAll('/', '').replaceAll(' ', '-'))
                          //     .delete().then((value) => print("Post eliminato"))
                          //     .catchError((error) => print("Failed to delete post: $error"));
                          // // print(ModalRoute.of(context).settings.name);
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


    // print(text+' prova1');
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
                // enabled: record.id == FirebaseAuth.instance.currentUser.uid,
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    // print(id+' '+idPost);
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
                        builder: (context) => MyProfile(user)),//.nameProfile, record.id.toString())),
                  );
                });


              },
              // trailing: Wrap(
              //   children: <Widget>[
              //     IconButton(icon: Icon(Icons.thumb_up) , onPressed: null),
              //     IconButton(icon: Icon(Icons.thumb_down), onPressed: null,)
              //   ],
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
                            // record.updateData({'upvote': upvote});
                            comments.remove(comment);
                            comment['upvote'] = upvote;
                            comment['idVotersLike']
                                .add(FirebaseAuth.instance.currentUser.uid);
                            // print(record);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            votatoLike = true;
                          } else if (votatoLike && !votatoDislike) {
                            upvote--;
                            // reference.updateData({'upvote': upvote});
                            comments.remove(comment);
                            comment['upvote'] = upvote;
                            comment['idVotersLike']
                                .remove(FirebaseAuth.instance.currentUser.uid);
                            // print(record);
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
                            // print(record);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            votatoDislike = true;
                          } else if (votatoDislike && !votatoLike) {
                            downvote--;
                            comments.remove(comment);
                            comment['downvote'] = downvote;
                            comment['idVotersDislike']
                                .remove(FirebaseAuth.instance.currentUser.uid);
                            // print(record);
                            comments.add(comment);
                            reference.update({'comments': comments});
                            // record.update({'comments': record});
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
    // return Container(
    //     margin: EdgeInsets.symmetric(vertical: 10.0),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           margin: const EdgeInsets.only(right: 16.0),
    //           child: CircleAvatar(child: Text('_name[0]')),
    //         ),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text('Antonio', style: Theme.of(context).textTheme.headline4),
    //             Container(
    //               margin: EdgeInsets.only(top: 5.0),
    //               child: Text(text),
    //             ),
    //           ],
    //         ),
    //       ],
    //     )
    // );
  }

  _downVote() {
    // setState(() {
    //   downvote++;
    // });
  }
// _upVote (){
// }
}

// class CommentPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: CustomAppBar(
//         appBar: AppBar(
//           title: Text('Commenti'),
//         ),
//         body: _buildBody(context)
//     );
//   }
//
//   Widget _buildBody(BuildContext context) {
//
//   }
// }

class CommentScreen extends StatefulWidget {
  List<Map<String, dynamic>> comments;

  DocumentReference reference;
  String idPost;
  Record record;
  int route;

  CommentScreen(record, comments, reference, int route) {
    this.comments = comments;
    // print('lista dei commenti?');
    // print(comments);
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
  // FirebaseMessaging _fcm = MyFeedPage().getFCM();
  var _listTokens;
  List<Map<String,dynamic>> listTokens  = new List<
      Map<String,
          dynamic>>();

  // List<Record> comments = [];
  List<Map<String, dynamic>> comments;

  void setComments(List<Comment> newComments) {
    this._comments = newComments;
  }

    // Get the current user
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    // String fcmToken = await _fcm.getToken();

    // // Save it to Firestore
    // if (fcmToken != null) {




  _CommentScreenState(record, comments, reference, route) {
    this.comments = comments;
    this.reference = reference;
    this.idPost = record.id;
    this.record=record;
    this.route = route;
    // this.comments = comment.map((data) => Record.fromMap(data)).toList();
    // comment.map((data)=> print(data['comment']));
    // print('comment');
    // print(FirebaseFirestore.instance.collection('subscribers').snapshots().toList());

    //       .forEach((result) {
    //     print(result.data());
    //   });
    // });
    for (var data in comments) {
      if (data['nameProfile'] != '')
        _comments.add(Comment(idPost, record, data, reference, comments));
    }
    print(_comments);
    _comments.sort((a, b) {
      return a.compareTo(b.comment);
    });
    // print('ANTONIOO');
    // print(_comments.record['upvote']);
    // comments.map((data)=> print(data));
    // _comments.add(Comment(text: comments[0]['comment'].toString()));
    // comments.map((data)=> print(data));
    // print(_comments);
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


    // print(listTokens);
      // setState(() {

      // _comments = [];
      // for (var data in comments) {
      //   Comment tmp = Comment(idPost, data, reference, comments);
      //   if (!_comments.contains(tmp))
      //
      //     _comments.add(tmp);
      // }
      // _comments.sort((a, b) {
      //   return a.compareTo(b.record);
      // });
      // });
      return Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffbb448), Color(0xfff7892b)])),
              //

            ),
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back_ios),
            // onPressed: () {
            //   Navigator.of(context).pop();
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => FeedPage()),
            //   );
            //
            // }
            // ),
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
      // print(FeedPage().getInfo()['verified']);
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

    // _saveDeviceToken(reference, nameProfile) async {
    //   // Get the current user
    //   // FirebaseUser user = await _auth.currentUser();
    //
    //   // Get the token for this device
    //   String fcmToken = await _fcm.getToken();
    //   if(!listTokens.contains({'token': fcmToken,
    //   'name': nameProfile,}) ){
    //     listTokens.add({'token': fcmToken,
    //       'name': nameProfile,});
    //   }
    //   // Save it to Firestore
    //   if (fcmToken != null) {
    //     reference.update({'tokens': listTokens
    //     });
    //     var tokens = reference.collection('tokens')
    //         .doc(fcmToken);
    //
    //     await tokens.set({
    //       'token': fcmToken,
    //       'name': nameProfile, // optional
    //     });
    //   }
    // }

    void _handleSubmitted_tmp(comment) {
      // FirebaseFirestore.instance.collection("subscribers").doc(id_accesso.toString()).get().then((querySnapshot) {
      //   _handleSubmitted(comment, querySnapshot.data()['nameProfile']);});

      FirebaseFirestore.instance
          .collection('subscribers')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) => _handleSubmitted(comment, value['name']));
    }


    Future<void> _handleSubmitted(comment, nameProfile) async {
      // _textController.clear();
      //   Comment comment = Comment(
      //     );
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
        print('notification');
        print(map['id']);
        print(record.id);
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


      // _focusNode.requestFocus();
      _textController.clear();
      // print(comments);
      //write newEntry to Firebase
    }

}
