import 'dart:core';

import 'package:flutter/material.dart';

class Comment extends StatefulWidget implements Comparable{


  Map<String,dynamic> record;//=[{'nameProfile':'','comment':'','upvote':'0','downvote':0}];

  // Record record;
  Comment(record) {
      this.record = record;
    // else
    //   this.record =[{'comments':[{'nameProfile':'','comment':'','upvote':0,'downvote':0}]}];
  }

  @override
  _CommentState createState() => _CommentState(record);
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
  bool votatoLike = false;
  bool votatoDislike = false;

  _CommentState(record){
    this.text = record['comment'];
    this.upvote = record['upvote'];
    this.downvote = record['downvote'];
    this.record = record;
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
                                record['upvote'] = upvote;
                                votatoLike = true;
                              }
                              else if(votatoLike && !votatoDislike){
                                upvote--;
                                record['upvote'] = upvote;
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
                          color: votatoDislike? Colors.red : Colors.grey,

                      icon: Icon(Icons.thumb_down),
                      onPressed: (){

                        setState(() {
                          if(!votatoDislike && !votatoLike) {
                            downvote++;
                            record['downvote'] = downvote;
                            votatoDislike = true;
                          }
                          else if(votatoDislike && !votatoLike){
                            downvote--;
                            record['downvote'] = downvote;
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

  CommentScreen(comments) {
    this.comments = comments;
  }

  @override
  _CommentScreenState createState() => _CommentScreenState(comments);
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> _comments = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  // List<Record> comments = [];
  List<Map<String, dynamic>> comments;

  _CommentScreenState(comment) {
    this.comments = comment;
    // this.comments = comment.map((data) => Record.fromMap(data)).toList();
    // comment.map((data)=> print(data['comment']));
    // print(comment);
    //TODO read data from Firebase
    for (var data in comment) {
      if(data['nameProfile']!='')
        _comments.add(Comment(data));
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
      appBar: AppBar(title: Text('Commenti')),
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
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Invia un commento'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(comments)),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(comment) {
    // _textController.clear();
    //   Comment comment = Comment(
    //     );
    if(_textController.text == '') return;
    var newEntry = {
      'nameProfile': 'Pippo',
      'comment': _textController.text,
      'upvote': 0,
      'downvote': 0
    };
    comments.add(newEntry);
    setState(() {
      _comments.add(Comment(newEntry));
    });
    _focusNode.requestFocus();
    _textController.clear();
    print(comments);
    //TODO write newEntry to Firebase
  }
}
