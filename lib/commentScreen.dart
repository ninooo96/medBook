import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'feedPage.dart';

class Comment extends StatefulWidget implements Comparable{


  var record;//=[{'nameProfile':'','comment':'','upvote':'0','downvote':0}];
  DocumentReference reference;
  List<Map<String,dynamic>> comments;
  // Record record;
  Comment(record, reference, comments) {
      this.record = record;
      this.reference = reference;
      this.comments = comments;
    // else
    //   this.record =[{'comments':[{'nameProfile':'','comment':'','upvote':0,'downvote':0}]}];
  }

  @override
  _CommentState createState() => _CommentState(record, reference, comments);
  @override
  int compareTo(other) {
    if(this.record['upvote']-this.record['downvote']<other['upvote']-other['downvote'])
      return -1;
    if(this.record['upvote']-this.record['downvote']>other['upvote']-other['downvote'])
      return 1;
    if(this.record['upvote']-this.record['downvote']==other['upvote']-other['downvote'])
      return 0;
    return null;
  }
}

class _CommentState extends State<Comment>{
  var record;
  String text;
  int upvote;
  int downvote;
  bool votatoLike;
  bool votatoDislike;
  DocumentReference reference;
  List<Map<String,dynamic>> comments;


  _CommentState(record, reference, comments){
    this.text = record['comment'];
    this.upvote = record['upvote'];
    this.downvote = record['downvote'];
    this.record = record;
    print('quale record?');
    print(record);
    this.reference = reference;
    this.comments = comments;
    this.votatoLike = record['idVotersLike'].contains(FirebaseAuth.instance.currentUser.uid) ? true : false;
    this.votatoDislike = record['idVotersDislike'].contains(FirebaseAuth.instance.currentUser.uid) ? true : false;
  }




  @override
  Widget build(BuildContext context) {

    // print(text+' prova1');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle_outlined, size: 50.0),
              title: Text(
                record['nameProfile'],
                textScaleFactor: 1.2,
              ),
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
                        color: votatoLike? Colors.green : Colors.grey,
                          onPressed: (){
                            setState(() {
                              if(!votatoLike && !votatoDislike) {
                                upvote++;
                                // record.updateData({'upvote': upvote});
                                comments.remove(record);
                                record['upvote'] = upvote;
                                record['idVotersLike'].add(FirebaseAuth.instance.currentUser.uid);
                                print(record);
                                comments.add(record);
                                reference.update({'comments':comments});
                                votatoLike = true;
                              }
                              else if(votatoLike && !votatoDislike){
                                upvote--;
                                // reference.updateData({'upvote': upvote});
                                comments.remove(record);
                                record['upvote'] = upvote;
                                record['idVotersLike'].remove(FirebaseAuth.instance.currentUser.uid);
                                print(record);
                                comments.add(record);
                                reference.update({'comments':comments});
                                votatoLike =false;
                              }
                            });

                          },
    )),
                    Flexible(

                      child: Text((upvote - downvote).toString()),

                    ),
                    Flexible(
                        child: IconButton(
                          color: votatoDislike ? Colors.red  : Colors.grey,

                      icon: Icon(Icons.thumb_down),
                      onPressed: (){

                        setState(() {
                          if(!votatoDislike && !votatoLike) {
                            downvote++;
                            comments.remove(record);
                            record['downvote'] = downvote;
                            record['idVotersDislike'].add(FirebaseAuth.instance.currentUser.uid);
                            print(record);
                            comments.add(record);
                            reference.update({'comments':comments});
                            votatoDislike = true;
                          }
                          else if(votatoDislike && !votatoLike){
                            downvote--;
                            comments.remove(record);
                            record['downvote'] = downvote;
                            record['idVotersDislike'].remove(FirebaseAuth.instance.currentUser.uid);
                            print(record);
                            comments.add(record);
                            reference.update({'comments':comments});
                            // record.update({'comments': record});
                            votatoDislike =false;
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

  CommentScreen(comments, reference) {
    this.comments = comments;
    // print('lista dei commenti?');
    // print(comments);
    this.reference = reference;

  }

  @override
  _CommentScreenState createState() => _CommentScreenState(comments, reference);
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> _comments = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DocumentReference reference;

  // List<Record> comments = [];
  List<Map<String, dynamic>> comments;

  _CommentScreenState(comment, reference) {
    this.comments = comment;
    this.reference = reference;
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
      if(data['nameProfile']!='')
        _comments.add(Comment(data, reference, comments));
    }
    _comments.sort((a,b) {
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
                  onPressed: () => _handleSubmitted_tmp(comments )),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted_tmp(comment){
    // FirebaseFirestore.instance.collection("subscribers").doc(id_accesso.toString()).get().then((querySnapshot) {
    //   _handleSubmitted(comment, querySnapshot.data()['nameProfile']);});

    FirebaseFirestore.instance
        .collection('subscribers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
        _handleSubmitted(comment, value['name'] +
            " " +
            value['surname']));
  }

  void _handleSubmitted(comment, nameProfile) {
    // _textController.clear();
    //   Comment comment = Comment(
    //     );

    if(_textController.text == '') return;
    var newEntry = {
      'nameProfile': nameProfile ,
      'comment': _textController.text,
      'upvote': 0,
      'downvote': 0,
      'idVotersLike':[],
      'idVotersDislike': []
    };

    comment.add(newEntry);
    reference.update({'comments':comment});
    setState(() {
      _comments.add(Comment(newEntry, reference, comments));
    });
    _focusNode.requestFocus();
    _textController.clear();
    print(comments);
    //TODO write newEntry to Firebase
  }
}
