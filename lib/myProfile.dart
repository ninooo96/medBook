import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medbook/feedPage.dart';
import 'commentScreen.dart';
import 'setting.dart';
import 'newPostScreen.dart';

String title;


class MyProfile extends StatefulWidget {
  // String title ;
  // int id_profile;
  var id_profile;
  MyProfile(id){
    this.id_profile = id;
  }
//   String getTitle(){
//     return title;
// }

  @override
  _MyProfileState createState() => _MyProfileState(id_profile);


  // nameProfile(){
  //   for(var elem in dummySnapshot){
  //     if(elem['id'] == id_accesso) {
  //       print(elem['nameProfile']);
  //       return elem['nameProfile'];
  //     }
  //     return '404';
  //   }
  // }
}

class _MyProfileState extends State<MyProfile> {
  var id_profile;
  _MyProfileState(id){
    this.id_profile = id;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('subscribers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        print('OK2');
        // print(snapshot.data.docs[id_accesso-1]['nameProfile']);
        return  _build(context, snapshot.data.docs[id_profile-1]['nameProfile']);
      },
    );
  }

  Widget _build(BuildContext context, String nameProfile){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _newPost();
        }, //new post page
        backgroundColor: Colors.orange,
        splashColor: Colors.yellow,
      ),
      drawer: Drawer(
          child: Column(
            children: <Widget> [
              drawDrawerHeader(),
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: _drawerTile()
              ),
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                        title: Text('Esci',textScaleFactor: 1.5,),
                        tileColor: Colors.red,
                        onTap: _logout,
                      )))
            ],
          )
      ),
      appBar: CustomAppBar(
        appBar: AppBar(
          //
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: _openDrawer,
          // ),
          title: Center(child: Text(nameProfile)),
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
      body: _buildBody(context, id_profile),
    );
  }

  Widget drawDrawerHeader() {
    return Container(
      height: 90.0,
      child: DrawerHeader(
        // child: Text('Specializzazioni',
        //     textScaleFactor: 1.8,
        //     textAlign: TextAlign.left,
        //     style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(color: Colors.orange),
          padding: EdgeInsets.symmetric(vertical: 25)),
    );
  }

  _drawerTile(){
    List<Widget> drawerTile = [];
    drawerTile.add(ListTile(
      title: Text('Home', textScaleFactor: 1.5,),
      onTap: (){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedPage()),
        );
      },
    ));
    drawerTile.add(Divider(thickness: 2,));
    drawerTile.add(ListTile(
      title: Text('Il mio profilo', textScaleFactor: 1.5,),
      onTap: (){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfile(id_profile)),
        );
      },
    ));
    drawerTile.add(Divider(thickness: 2,));
    drawerTile.add(ListTile(
      title: Text('Impostazioni',textScaleFactor: 1.5,),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Setting()),
        );
      },
    ));
    drawerTile.add(Divider(thickness: 2,));

    return drawerTile;
  }

  _logout(){
    //TODO scollegati da Firebase
  }
  void _postWithMyHashtags() {
    print("ciao Anto");
    //TODO pagina con i post di cui ho ricevuto la notifica perchè con il mio hashtag
  }

  void _search() {
    //TODO funzione di ricerca
  }


  _openDrawer() {}

  _newPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostScreen()),
    );
  }
}

Widget _buildBody(BuildContext context, int id_profile) {
  //TODO: estrai snapshot dal Cloud Firebase
  // List<Map> snapshot = dummySnapshot;
  // return _buildList(context, snapshot);
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('feed').orderBy('timestamp', descending:true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      print('OK');
      return _buildList(context, snapshot.data.docs, id_profile);
    },
  );
}


// Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot2) {

  // return StreamBuilder<QuerySnapshot>(
  //   stream: FirebaseFirestore.instance.collection('subscribers').snapshots(),
  //   builder: (context, snapshot) {
  //     if (!snapshot.hasData) return LinearProgressIndicator();
  //     print('OK2');
  //     // print(snapshot.data.docs[id_accesso-1]['nameProfile']);
  //     return  _buildList2(context, snapshot2, snapshot.data.docs[id_profile-1]['nameProfile'], id_profile);
  //   },
  // );
  //   print(FirebaseFirestore.instance.collection("subscribers").get());//doc(id_accesso.toString()).get()[0]());
      // return _buildList2(context, snapshot, querySnapshot.data()['nameProfile']);
  // }


Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, int id_profile) {
  // var snapshot2 = snapshot.where((id) => id==id_accesso);
  // print(snapshot2);
//
  return ListView(
    padding: const EdgeInsets.only(top: 5.0),
    //da giocarci dopo che visualizzo un post
  //     final record = Record.fromMap(data);
  // // print(record);
  // if( record.id==2){
  //   print(record.post);
    children: snapshot.map((data) => _buildListItem(context, data, id_profile)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, int id_profile) {
  var recordTmp;
  // title = nameProfile;
  if(Record.fromSnapshot(data).id!=id_profile) return Container();
  var record = Record.fromSnapshot(data);

  // if(recordTot.id==id_accesso){
  //   recordTmp = recordTot;
  // }
  // final record = recordTmp;
  print(record);
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
                    (record.sexPatient)+
                    (record.hashtags.length == 0 ? '':"\n# "+record.hashtags.toString().substring(1, record.hashtags.toString().length - 1))+ ""
                    "\n\n"+ record.post)),
            ListTile(
              title: record.comments.first.length > 0
                  ? record.comments.first.length > 1
                  ? Text(record.comments.length.toString() + ' commenti')
                  : Text(record.comments.toString() + ' commento')
                  : Text('Non ci sono commenti'),
              onTap: () {addComment(context,record.comments, record.reference, 0);},
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: ListTile(
                      onTap: (){addComment(context, record.comments, record.reference, 1);},
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

// void addComment(context, record, nuovoCommento) { //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
//   print('Ciao Lele' + record.length.toString(), );
//   print(record);
//   if(record.length==0)
//     record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0}];
//   print(record);
//   if(record.length != 1 || nuovoCommento==1) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CommentScreen(record, reference)),
//     );
//   }
//
// }
// void addComment(context, List<dynamic> record1, reference, nuovoCommento) { //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
//   print('Ciao Lele' + record1.length.toString() );
//   List<Map<String,dynamic>> record = new List<Map<String,dynamic>>();// la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
//   record1.forEach((data) => record.add({
//     'nameProfile' : data['nameProfile'],
//     'comment': data['comment'],
//     'upvote': data['upvote'],
//     'downvote' : data['downvote']
//   }));
//   if(record.length==0)
//     record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0}];
//   print(record);
//   if(record.length != 1 || nuovoCommento==1) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CommentScreen(record, reference)),
//     );
//   }
//
// }
void addComment(context, List<dynamic> record1, reference, nuovoCommento) { //nuovoCommento è un intero che vale 1 se clicco il tasto per aggiungere un nuovo commento, 0 else
  print('Ciao Lele' + record1.length.toString() );
  List<Map<String,dynamic>> record = new List<Map<String,dynamic>>();// la lista dei commenti collegati al post Dart non riesce a vederli come Mappa, quindi devo ricrearla
  print(nuovoCommento);
  // print(record1.first.length);
  if(record1.first.length!=0) {
    record1.forEach((data) =>
        record.add({
          'nameProfile': data['nameProfile'],
          'comment': data['comment'],
          'upvote': data['upvote'],
          'downvote': data['downvote'],
          'idVotersLike': data['idVotersLike'],
          'idVotersDislike': data['idVotersDislike']
        }));
  }


  // if(record.length==0)
  //   record =[{'nameProfile':'','comment':'','upvote':0,'downvote':0, 'idVotersLike':[0], 'idVotersDislike':[0]}];
  // print(record);
  if(record1.first.length != 0 || nuovoCommento==1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentScreen(record, reference)),
    );
  }

}





class Record {
  final String nameProfile;
  final String sexPatient;
  final String post;
  final int agePatient;
  final int numComment;
  final int id;

  final List comments;
  final List hashtags;

  final DocumentReference reference;


  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : nameProfile = map['nameProfile'],
        sexPatient = map['sexPatient'],
        agePatient = map['agePatient'],
        post = map['post'],
        numComment = map['numComment'],
        id = map['id'],
        hashtags = map['hashtags'],
        comments = map['comments'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);



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
