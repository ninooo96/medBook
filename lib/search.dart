import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medbook/feedPage.dart';
import 'package:medbook/postTile.dart';
import 'package:medbook/record.dart';
import 'package:medbook/risultatiRicerca.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController _ricercaUtente = TextEditingController();
  TextEditingController _ricercaGenerale = TextEditingController();
  TextEditingController _ricercaHashtag = TextEditingController();

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
        ),
        title: Text('Ricerca'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _entryField(
      String title, TextEditingController controller, String hintText,
      {bool isPassword = false, bool isEnabled = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  hintText: hintText,
                  enabled: isEnabled,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(

          children: [
            Text('Compila uno o più di questi campi per effettuare una ricerca', style:TextStyle(fontWeight: FontWeight.bold, fontSize: 22) ,),
            SizedBox(
              height: 10,
            ),
            _entryField('Ricerca utente', _ricercaUtente,
                'Inserisci il nome del profilo da ricercare'),


            // Divider(thickness: 2,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text('Ricerca per Post',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)
            //
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            _entryField('Hashtag', _ricercaHashtag, 'Es.: Cardiologia, Dermatologia, Ortopedia'),
            // _entryField('Parola chiave', _ricercaGenerale, 'Inserisci una parola chiave'),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [IconButton(icon: Icon(Icons.send,size: 40,), onPressed: null)],
            // ),
           
            _submitButton(context)
            ],
        ));
  }

  Widget _submitButton(context) {
    return GestureDetector(
        onTap: () {_search(context);},
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: Text(
        'Ricerca',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ));

  }


  titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      // You do not need to check if i is larger than splitStr length, as your for does that for you
      // Assign it back to the array
      splitStr[i] = splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join(' ').toString();
  }

  Widget _search(context) {
    if(_ricercaUtente.text!='' || _ricercaHashtag.text!=''){
      // print(_ricercaUtente.text.split(' ').length);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RisultatiRicerca(_ricercaUtente.text, _ricercaHashtag.text),
          )
      );
    }



    // return StreamBuilder<QuerySnapshot>(
    //   stream: stream
    //       .orderBy('timestamp', descending: true)
    //       .snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) return LinearProgressIndicator();
    //     print(snapshot.data.docs);
    //     return _buildList(context, snapshot.data.docs);
    //   },
    // );
  }

  Widget _buildList(BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      //da giocarci dopo che visualizzo un post

      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  _buildListItem(BuildContext context, QueryDocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    print(record);
    return PostTile( data, context,3);
  }
}
