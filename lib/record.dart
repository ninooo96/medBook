import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Record {
  final String nameProfile;
  final String sexPatient;
  final String post;
  final int agePatient;
  final int numComment;
  final String id;
  final String timestamp;
  final String profileImgUrl;

  final List comments;
  final List hashtags;
  final DocumentReference reference;
  final List listTokens;
  final String token;
  final bool yet_opened;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : nameProfile = map['nameProfile'],
        sexPatient = map['sexPatient'],
        agePatient = map['agePatient'],
        post = map['post'],
        numComment = map['numComment'],
        id = map['id'],
        timestamp = getTimestamp(map['timestamp']),
        hashtags = map['hashtags'],
        profileImgUrl = map['profileImgUrl'],
        listTokens = map['listTokens'],
        yet_opened = map['yet_opened'],
        token = map['token'],
        comments = map['comments'];


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(),
      reference: snapshot.reference); //prende solo il primo post

  String toString() => "Record<$nameProfile:$post>";

  static String getTimestamp(Timestamp timestamp) {
    var time = timestamp.toDate();
    final f = new DateFormat('dd/MM/yyyy').add_Hms();
    return f.format(time);
  }
}