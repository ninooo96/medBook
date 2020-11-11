import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserMB {
  final String nameProfile;
  final String monthBirth;
  final String provinciaOrdine;
  final String numOrdine;
  final String dayBirth;
  final String id;
  final String yearBirth;
  final String profileImgUrl;

  final List specializzazioni;
  final List topic;
  final DocumentReference reference;

  UserMB.fromMap(Map<String, dynamic> map, {this.reference})
      : nameProfile = map['name'],
        monthBirth = map['monthBirth'],
        id = map['id'],
        provinciaOrdine = map['provinciaOrdine'],
        numOrdine = map['numOrdine'],
        dayBirth = map['dayBirth'],
        yearBirth = map['yearBirth'],
        profileImgUrl = map['profileImgUrl'],
        topic = map['topic'],
        specializzazioni = map['specializzazioni'];


  UserMB.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(),
      reference: snapshot.reference); //prende solo il primo post

  String toString() => "User<$nameProfile:$id>";


}