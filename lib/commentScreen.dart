import 'package:flutter/material.dart';

import 'feedPage.dart';

class Comment extends StatelessWidget {
  String text;
  int upvote;
  int downvote;
  // Record record;
  Comment(record){
    this.text = record['comment'];
    this.upvote = record['upvote'];
    this.downvote = record['downvote'];
    // this.record = record;
    print(record['upvote']);
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
            children: <Widget> [
              ListTile(
                leading: Icon(Icons.account_circle_outlined, size: 50.0),
                title: Text('Prova', textScaleFactor: 1.2,),
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
                      Flexible(child:
                      IconButton(icon: Icon(Icons.thumb_up) , onPressed: null),),
                      Flexible(child:
                      Text((upvote-downvote).toString()),),
                      Flexible(child:
                      IconButton(icon: Icon(Icons.thumb_down), onPressed: null,)),

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

class CommentScreen extends StatefulWidget{
  List<Map<String, Object>> comments;
  CommentScreen(comments){
    this.comments = comments;
  }

  @override
  _CommentScreenState createState() => _CommentScreenState(comments);
}

class _CommentScreenState extends State<CommentScreen>{
  List<Comment> _comments = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Record> comments = [];

  _CommentScreenState(comment){
    // this.comments = comment.map((data) => Record.fromMap(data)).toList();
    // comment.map((data)=> print(data['comment']));
    // print(comment);
    for (var data in comment){
      _comments.add(Comment(data));
    }
    // comments.map((data)=> print(data));
    // _comments.add(Comment(text: comments[0]['comment'].toString()));
    // comments.map((data)=> print(data));
    // print(_comments);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text ('Commenti')),
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
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor),
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
                decoration: InputDecoration.collapsed(hintText: 'Invia un commento'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
  //   _textController.clear();
  //   Comment comment = Comment(
  //     );
  //   setState(() {
  //     _comments.insert(0, comment);
  //   });
  //   _focusNode.requestFocus();
  }
}



