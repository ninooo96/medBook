import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

final dummySnapshot = [
  {'nameProfile': 'Antonio Gagliostro', 'agePatient': 67, 'sexPatient': 'Male', 'post':'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'},
  {'nameProfile':'Chiara Del Re', 'agePatient':79, 'sexPatient':'Female','post':'Diagnosi2'},
  {'nameProfile': 'Antonio Gagliostro', 'agePatient': 67, 'sexPatient': 'Male', 'post':'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'},
  {'nameProfile': 'Antonio Gagliostro', 'agePatient': 67, 'sexPatient': 'Male', 'post':'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'},

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
      appBar: CustomAppBar(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: _search),
            IconButton(icon: Icon(Icons.notifications), onPressed: _postWithMyHashtags,),
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
}

  Widget _buildBody(BuildContext context) {
    //TODO: estrai snapshot dal Cloud Firebase
    List<Map> snapshot = dummySnapshot;
    return _buildList(context, snapshot);
  }

  Widget _buildList(BuildContext context, List<Map> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top:20.0), //da giocarci dopo che visualizzo un post
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Map data) {
    final record = Record.fromMap(data);

    return Padding(
      // key: ValueKey(record.nameProfile),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          trailing: Icon(Icons.add_comment_rounded),
          leading: Icon(Icons.account_circle_outlined, size: 50.0),
          title: Text(record.nameProfile),
          subtitle: Text('Età: ' + (record.agePatient).toString() + ', Sesso: ' + (record.sexPatient == 'Male' ? 'Maschile':"Femminile") +"\n\n"+ record.post ),
          isThreeLine: true,

        ),

      )
    );
}

class Record {
  final String nameProfile;
  final String sexPatient;
  final String post;
  final int agePatient;
  // final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map) :
        nameProfile = map['nameProfile'],
        sexPatient = map['sexPatient'],
        agePatient = map['agePatient'],
        post = map['post'];

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
