

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'feedPage.dart';
class Utility {
  saveDeviceToken(reference, nameProfile, {bool segui= false}) async {
    // Get the current user
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device

    FirebaseMessaging _fcm = MyFeedPage().getFCM();
    String fcmToken = await _fcm.getToken();
    print(fcmToken);
    // if(!listTokens.contains({'token': fcmToken,
    //   'name': nameProfile,}) ){
    //   listTokens.add({'token': fcmToken,
    //     'name': nameProfile,});
    // }
    // Save it to Firestore

    if (fcmToken != null) {
      // reference.update({'tokens': listTokens
      reference.updateData({"listTokens": FieldValue.arrayUnion([{'token': fcmToken,
              'name': nameProfile,}])});
    };
    if(!segui) {
      var tokens = reference.collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'name': nameProfile, // optional
      });
    }
  }

  removeDeviceToken(reference, nameProfile,{bool segui = false}) async {
    // Get the current user
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device

    FirebaseMessaging _fcm = MyFeedPage().getFCM();
    String fcmToken = await _fcm.getToken();
    print(fcmToken);
    // if(!listTokens.contains({'token': fcmToken,
    //   'name': nameProfile,}) ){
    //   listTokens.add({'token': fcmToken,
    //     'name': nameProfile,});
    // }
    // Save it to Firestore
    if (fcmToken != null) {
      // reference.update({'tokens': listTokens
      reference.updateData({"listTokens": FieldValue.arrayRemove([{'token': fcmToken,
        'name': nameProfile,}])});
    };
    if(!segui) {
      DocumentReference tokens = reference.collection('tokens')
          .doc(fcmToken);

      await tokens.delete();
    }
  }
}
