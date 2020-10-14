import 'package:flutter/material.dart';

import 'feedPage.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final hashtagPost = [];
  final _textController = TextEditingController();
  final _sessoController = TextEditingController();
  final _etaController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
            child: ListView(
          children: [drawDrawerHeader(), _populateHashtags()],
        )),
        appBar: AppBar(title: Text('Nuovo Post'),actions: [Container()],),

        body: _buildBody(context));
  }

  Widget drawDrawerHeader() {
    return Container(
      height: 100.0,
      child: DrawerHeader(
          child: Text('Specializzazioni',
              textScaleFactor: 1.8,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(color: Colors.orange),
          padding: EdgeInsets.symmetric(vertical: 25)),
    );
  }

  Widget _populateHashtags() {
    // return ListTile(
    //   title: Text('prova')
    // );
    List<ListTile> specializzazioni = [];
    for (var hashtag in hashtags) {
      specializzazioni.add(ListTile(
        title: Text(
          hashtag,
          textScaleFactor: 1.5,
        ),
        onTap: () {
          setState(() {
            if (hashtagPost.contains(hashtag)) {
              hashtagPost.remove(hashtag);
            } else
              hashtagPost.add(hashtag);
          });
        },
      ));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemBuilder: (_, int index) => specializzazioni[index],
      itemCount: specializzazioni.length,
    );
    // return Scaffold(
    //   endDrawer: Drawer(
    //       child: ListView(
    //         children: [
    //           DrawerHeader(),
    //           _populateHashtags()
    //
    //         ],
    //       )
    //   ),
    // );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 0.5,
                      )),
                      labelText: 'Sesso',
                    ),
                    controller: _sessoController,
                  )),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 0.5,
                        )),
                        labelText: 'Età'),
                    controller: _etaController,
                  )),
                ]),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                      )),
                      hintText: 'Scrivi il tuo post...',
                    ),
                    controller: _textController,
                    maxLines: double.maxFinite.floor(),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [_hashtagRow()],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: _attachPhoto,
                    ),
                    IconButton(
                      icon: Icon(Icons.tag),
                      onPressed: _addTag,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendPost,
                    ),
                  ],
                )
              ],
            )));
  }

  void _attachPhoto() {
    //TODO fai una foto o prendila dalla galleria
  }

  _hashtagRow() {
    List<String> text = [];
    if (hashtagPost.isNotEmpty) {
      for (var h in hashtagPost) {
        text.add(h);
      }
      // String hashtag = text[0]+', ';
      var tmp = text.toString();
      print(tmp);
      return Text(tmp.substring(1, tmp.length - 1), textScaleFactor: 1.1,);
    }
    return Text('');
  }

  void _addTag() {
    // Scaffold.of(context).openEndDrawer();
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _sendPost() {
    //TODO send post to firebase
  }
}
