import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medbook/notification.dart';
import 'package:medbook/postTile.dart';

import 'feedPage.dart';

class OpenNotification extends StatefulWidget {
  /**route == 1 => tap sulla schermata notifiche
   * route ==2 => tap dalla notifica nel menù a tendina
   */
  int route;
  DocumentSnapshot doc;

  OpenNotification(doc, route) {
    this.doc = doc;
    this.route = route;
  }

  @override
  OpenNotificationState createState() => OpenNotificationState(doc, route);
}

class OpenNotificationState extends State<OpenNotification> {
  DocumentSnapshot doc;
  int route;

  OpenNotificationState(doc, route) {
    this.doc = doc;
    this.route = route;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (route == 1) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                } else if (route == 2) {
                  print('ciao');
                  // Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.push( context, MaterialPageRoute(builder: (BuildContext context) => new FeedPage()));

                }
              }),
          // title: Text(),
        )),
        body: Wrap(children: [PostTile(doc, context, 3)]));
    // PostTile(value, context, 3),
  }
}
