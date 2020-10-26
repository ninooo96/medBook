import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medbook/user.dart';

import 'feedPage.dart';
import 'myProfile.dart';

class Comment extends StatefulWidget implements Comparable {
  var record; //=[{'nameProfile':'','comment':'','upvote':'0','downvote':0}];
  DocumentReference reference;
  List<Map<String, dynamic>> comments;
  String idPost;
  // List<Comment> _comments;

  // Record record;
  Comment(idPost, record, reference, comments) {
    this.record = record;
    this.reference = reference;
    this.comments = comments;
    this.idPost = idPost;
    // this._comments = _comments;
    // else
    //   this.record =[{'comments':[{'nameProfile':'','comment':'','upvote':0,'downvote':0}]}];
  }

  @override
  _CommentState createState() => _CommentState(idPost, record, reference, comments);

  @override
  int compareTo(other) {
    if (this.record['upvote'] - this.record['downvote'] <
        other['upvote'] - other['downvote']) return -1;
    if (this.record['upvote'] - this.record['downvote'] >
        other['upvote'] - other['downvote']) return 1;
    if (this.record['upvote'] - this.record['downvote'] ==
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
  DocumentReference reference;
  List<Map<String, dynamic>> comments;
  String profileImgUrl;
  String id;
  String idPost;
  bool deleted = false;
  // List<Comment> _comments;

  _CommentState(idPost, record, reference, comments) {
    this.text = record['comment'];
    this.id = record['id'];
    this.upvote = record['upvote'];
    this.downvote = record['downvote'];
    this.profileImgUrl = record['profileImgUrl'];
    this.record = record;
    print('quale record?');
    print(record);
    this.reference = reference;
    // this._comments = _comments;
    this.comments = comments;
    this.idPost = idPost;
    this.votatoLike =
        record['idVotersLike'].contains(FirebaseAuth.instance.currentUser.uid)
            ? true
            : false;
    this.votatoDislike = record['idVotersDislike']
            .contains(FirebaseAuth.instance.currentUser.uid)
        ? true
        : false;
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
                          print(record);
                          setState(() {
                            comments.remove(record);
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
                            print(comments);
                            reference.update({'comments': comments});
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            deleted = true;
                          });
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
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.hardEdge,
                      child:
                          Image.network(profileImgUrl, height: 50, width: 50)),

              trailing: PopupMenuButton<String>(
                // enabled: record.id == FirebaseAuth.instance.currentUser.uid,
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    print(id+' '+idPost);
                    return {'Elimina commento'}
                        .map((String choice) {
                      return PopupMenuItem<String>(

                          enabled: id == FirebaseAuth.instance.currentUser.uid || idPost==FirebaseAuth.instance.currentUser.uid, //se sono l'autore del post o l'autore del commento

                          value: choice, child: Text(choice));
                    }).toList();
                  }),
              title: Text(
                record['nameProfile'],
                textScaleFactor: 1.2,
              ),
              onTap: () {
                FirebaseFirestore.instance.collection('subscribers').doc(record['id']).get().then((value) {
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
                      color: votatoLike ? Colors.green : Colors.grey,
                      onPressed: () {
                        setState(() {
                          if (!votatoLike && !votatoDislike) {
                            upvote++;
                            // record.updateData({'upvote': upvote});
                            comments.remove(record);
                            record['upvote'] = upvote;
                            record['idVotersLike']
                                .add(FirebaseAuth.instance.currentUser.uid);
                            print(record);
                            comments.add(record);
                            reference.update({'comments': comments});
                            votatoLike = true;
                          } else if (votatoLike && !votatoDislike) {
                            upvote--;
                            // reference.updateData({'upvote': upvote});
                            comments.remove(record);
                            record['upvote'] = upvote;
                            record['idVotersLike']
                                .remove(FirebaseAuth.instance.currentUser.uid);
                            print(record);
                            comments.add(record);
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
                      color: votatoDislike ? Colors.red : Colors.grey,
                      icon: Icon(Icons.thumb_down),
                      onPressed: () {
                        setState(() {
                          if (!votatoDislike && !votatoLike) {
                            downvote++;
                            comments.remove(record);
                            record['downvote'] = downvote;
                            record['idVotersDislike']
                                .add(FirebaseAuth.instance.currentUser.uid);
                            print(record);
                            comments.add(record);
                            reference.update({'comments': comments});
                            votatoDislike = true;
                          } else if (votatoDislike && !votatoLike) {
                            downvote--;
                            comments.remove(record);
                            record['downvote'] = downvote;
                            record['idVotersDislike']
                                .remove(FirebaseAuth.instance.currentUser.uid);
                            print(record);
                            comments.add(record);
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

  CommentScreen(idPost, comments, reference) {
    this.comments = comments;
    // print('lista dei commenti?');
    // print(comments);
    this.reference = reference;
    this.idPost = idPost;
  }

  @override
  _CommentScreenState createState() => _CommentScreenState(idPost, comments, reference);
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> _comments = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DocumentReference reference;
  String idPost;

  // List<Record> comments = [];
  List<Map<String, dynamic>> comments;

  void setComments(List<Comment> newComments){
    this._comments=newComments;
  }


  _CommentScreenState(idPost, comment, reference) {
    this.comments = comment;
    this.reference = reference;
    this.idPost = idPost;
    // this.comments = comment.map((data) => Record.fromMap(data)).toList();
    // comment.map((data)=> print(data['comment']));
    // print('comment');
    // print(FirebaseFirestore.instance.collection('subscribers').snapshots().toList());

    //       .forEach((result) {
    //     print(result.data());
    //   });
    // });
    //TODO read data from Firebase
    for (var data in comment) {
      if (data['nameProfile'] != '')
        _comments.add(Comment(idPost, data, reference, comments));
    }
    _comments.sort((a, b) {
      return a.compareTo(b.record);
    });
    // print('ANTONIOO');
    // print(_comments.record['upvote']);
    // comments.map((data)=> print(data));
    // _comments.add(Comment(text: comments[0]['comment'].toString()));
    // comments.map((data)=> print(data));
    // print(_comments);
  }

  @override
  Widget build(BuildContext context) {
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
            // leading: IconButton(
            //   icon: Icon(Icons.menu),
            //   onPressed: _openDrawer,
            // ),
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
          title: Text('Commenti')),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _comments[index],
              itemCount: _comments.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
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
    // FirebaseFirestore.instance.collection("subscribers").doc(id_accesso.toString()).get().then((querySnapshot) {
    //   _handleSubmitted(comment, querySnapshot.data()['nameProfile']);});

    FirebaseFirestore.instance
        .collection('subscribers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) => _handleSubmitted(comment, value['name']));
  }

  void _handleSubmitted(comment, nameProfile) {
    // _textController.clear();
    //   Comment comment = Comment(
    //     );

    if (_textController.text == '') return;
    var newEntry = {
      'nameProfile': nameProfile,
      'comment': _textController.text,
      'upvote': 0,
      'downvote': 0,
      'idVotersLike': [],
      'idVotersDislike': [],
      'profileImgUrl': info['profileImgUrl'],
      'id': FirebaseAuth.instance.currentUser.uid
    };

    comments.add(newEntry);
    reference.update({'comments': comment});
    setState(() {
      _comments.add(Comment(idPost, newEntry, reference, comments));
    });
    // _focusNode.requestFocus();
    _textController.clear();
    print(comments);
    //TODO write newEntry to Firebase
  }
}
