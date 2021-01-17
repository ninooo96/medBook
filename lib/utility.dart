

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'feedPage.dart';
class Utility {
  saveDeviceToken(reference, nameProfile, id, {String timestamp = '', bool segui= false}) async {

    // Get the token for this device

    FirebaseMessaging _fcm = FeedPage().getFCM();
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore

    if (fcmToken != null) {
      reference.updateData({"listTokens": FieldValue.arrayUnion([{'token': fcmToken,
              'name': nameProfile, 'id' : id}])});
    };
    if(!segui) {
      var tokens = reference.collection('tokens')
          .doc(fcmToken+'_'+timestamp);

      await tokens.set({
        'token': fcmToken,
        'name': nameProfile,
        'id': id
      });
    }
  }

  removeDeviceToken(reference, nameProfile, id, token, {List listToken=const [], String timestamp ='', bool segui = false}) async {


    // Save it to Firestore
    if (token != null) {
      reference.updateData({"listTokens": FieldValue.arrayRemove([{'token': token,
        'name': nameProfile, 'id' : id}])});
      if(timestamp!='') {
        for (var map in listToken) {
          await FirebaseFirestore.instance
              .collection('subscribers')
              .doc(map['id'])
              .collection('notification')
              .doc(id + "_" + timestamp)
              .delete();
        }
      }
    };
    if(!segui) {
      DocumentReference tokens = reference.collection('tokens')
          .doc(token.toString()+'_'+timestamp);

      await tokens.delete();
    }
  }
}
