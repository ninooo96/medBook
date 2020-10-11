import 'package:flutter/material.dart';

import 'commentScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

final dummySnapshot = [
  {
    'nameProfile': 'Antonio Gagliostro',
    'agePatient': 67,
    'sexPatient': 'Male',
    'post':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    'numComment': 2,
    'comments': [
      {
        'nameProfile': 'Chiara Del Re',
        'comment': 'ciao',
        'upvote': 3,
        'downvote': 7
      },
      {
        'nameProfile': 'Dott. House',
        'comment': 'ciao Antonio',
        'upvote': 2,
        'downvote': 7
      },
    ]
  },
  {
    'nameProfile': 'Chiara Del Re',
    'agePatient': 79,
    'sexPatient': 'Female',
    'post': 'Diagnosi2',
    'numComment': 1,
    'comments': [
      {
        'nameProfile': 'Dott.ssa Peluche',
        'comment': 'ciao Chiara',
        'upvote': 5,
        'downvote': 5
      },
    ]
  },
  {
    'nameProfile': 'Antonio Gagliostro',
    'agePatient': 67,
    'sexPatient': 'Male',
    'post':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    'numComment': 0,
    'comments': []
  },
  {
    'nameProfile': 'Antonio Gagliostro',
    'agePatient': 67,
    'sexPatient': 'Male',
    'post':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    'numComment': 0,
    'comments': []
  },
];

class FeedPage extends StatelessWidget {
  // @override
  Widget build(BuildContext context) {
    //   // TODO: scrolling di ListView dei post
    return MaterialApp(
      title: 'MedBook',
      theme: ThemeData(primaryColor: Colors.orange),
      home: MyFeedPage(title: 'MedBook'),
    );
  }
}

class MyFeedPage extends StatefulWidget {
  MyFeedPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {}, //new post page
        backgroundColor: Colors.orange,
        splashColor: Colors.yellow,
      ),

      appBar: CustomAppBar(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: _openDrawer,
          ),
          title: Center(child: Text(widget.title)),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: _search),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: _postWithMyHashtags,
            ),

          ],
        ),
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => PostTile()),
        //   );
        // },
      ),
      body: _buildBody(context),
    );
  }

  void _postWithMyHashtags() {
    print("ciao Anto");
    //TODO pagina con i post di cui ho ricevuto la notifica perchè con il mio hashtag
  }

  void _search() {
    //TODO funzione di ricerca
  }



  _openDrawer() {}
}

Widget _buildBody(BuildContext context) {
  //TODO: estrai snapshot dal Cloud Firebase
  List<Map> snapshot = dummySnapshot;
  return _buildList(context, snapshot);
}

Widget _buildList(BuildContext context, List<Map> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 5.0),
    //da giocarci dopo che visualizzo un post
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, Map data) {
  final record = Record.fromMap(data);

  return Padding(
      // key: ValueKey(record.nameProfile),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(children: <Widget>[
            ListTile(
                leading: Icon(Icons.account_circle_outlined, size: 50.0),
                title: Text(record.nameProfile),
                ),
            ListTile(
                title: Text('Età: ' +
                    (record.agePatient).toString() +
                    ', Sesso: ' +
                    (record.sexPatient == 'Male' ? 'Maschile' : "Femminile")+ "\n\n"+ record.post)),
            ListTile(
                title: record.numComment > 0
                    ? record.numComment > 1
                        ? Text(record.numComment.toString() + ' commenti')
                        : Text(record.numComment.toString() + ' commento')
                    : Text('Non ci sono commenti'),
                onTap: () {addComment(context,record.comments, 0);},
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: ListTile(
                      onTap: (){addComment(context, record.comments, 1);},
                      title: Center(child: Text('Commenta')),
                )),
                Container(height: 30, child: VerticalDivider(color: Colors.grey, thickness: 2,)),
                Flexible(
                    child: ListTile(
                      onTap: _activeNotifications,
                      title: Center(child: Text('Segui'))))
              ],
            )
          ])));
}

void addComment(context, record, nuovoCommento) { //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
  print('Ciao Lele' + record.length.toString(), );
  if(record.length != 0 || nuovoCommento==1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentScreen(record)),
    );

  }

}


// }


class Record {
  final String nameProfile;
  final String sexPatient;
  final String post;
  final int agePatient;
  final int numComment;

  final List comments;

  // final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map)
      : nameProfile = map['nameProfile'],
        sexPatient = map['sexPatient'],
        agePatient = map['agePatient'],
        post = map['post'],
        numComment = map['numComment'],

        comments = map['comments'];



  String toString() => "Record<$nameProfile:$post>";
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



void _activeNotifications() {}

String _visualizeComments(record){
  print(record.comments.map((data)=> data['comment'].toString()));
  return record.comments.map((data)=> data['comment'][0].toString());
}
