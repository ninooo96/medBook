// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:medbook/user.dart';
//
// import 'myProfile.dart';
//
// Widget Comment(
//     String idPost,
//     Map<String, dynamic> record,
//     DocumentReference reference,
//     List<Map<String, dynamic>> comments,
//     List<Widget> _comments,
//     BuildContext context) {
//   String text = record['comment'];
//   String id = record['id'];
//   int upvote = record['upvote'];
//   int downvote = record['downvote'];
//   String profileImgUrl = record['profileImgUrl'];
//   bool votatoLike =
//       record['idVotersLike'].contains(FirebaseAuth.instance.currentUser.uid)
//           ? true
//           : false;
//   bool votatoDislike =
//       record['idVotersDislike'].contains(FirebaseAuth.instance.currentUser.uid)
//           ? true
//           : false;
//
//   void handleClick(String value) {
//     switch (value) {
//       case 'Elimina commento':
//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Sicuro di voler eliminare il commento?"),
//                 content: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FlatButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           'No',
//                           textScaleFactor: 1.5,
//                         )),
//                     FlatButton(
//                         onPressed: () {
//                           // Navigator.of(context).pop();
//                           print(record);
//                           setState(() {
//                           comments.remove(record);
//                           _comments = [];
//                           for (var data in comments) {
//                             if (data['nameProfile'] != '')
//                               _comments.add(Comment(idPost, data, reference,
//                                   comments, _comments, context));
//                           }
//                           // _comments.sort((a, b) {
//                           //   a.compareTo(b.record);
//                           // });
//                           // _comments =_comments2;
//                           });
//                           if (comments.isEmpty)
//                             reference.update({
//                               'comments': [{}]
//                             });
//                           else {
//                             print(comments);
//                             reference.update({'comments': comments});
//                           }
//                           Navigator.of(context).pop();
//                           // Navigator.of(context).reassemble();
//                           // print(Navigator.of(context).canPop());
//                           // if(Navigator.of(context).canPop() ) {
//
//                           // }
//                           // Navigator.of(context).pop();
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //       builder: (context) => CommentScreen(idPost, comments, reference)),//.nameProfile, record.id.toString())),
//                           // );
//                           //
//                           // });
//                           // // DateTime date = record.t
//                           // // print(record.timestamp.replaceAll('/', '').replaceAll(' ', '-'));
//                           // print(record.nameProfile.toLowerCase().replaceAll(' ', '')+'_'+FirebaseAuth.instance.currentUser.uid+'-'+record.timestamp.replaceAll('/', '').replaceAll(' ', '-'));
//                           // Navigator.of(context).pop();
//                           // FirebaseFirestore.instance.collection('feed')
//                           //     .doc(record.nameProfile.toLowerCase().replaceAll(' ', '')+'_'+FirebaseAuth.instance.currentUser.uid+'-'+record.timestamp.replaceAll('/', '').replaceAll(' ', '-'))
//                           //     .delete().then((value) => print("Post eliminato"))
//                           //     .catchError((error) => print("Failed to delete post: $error"));
//                           // // print(ModalRoute.of(context).settings.name);
//                         },
//                         child: Text(
//                           'Sì',
//                           textScaleFactor: 1.5,
//                         ))
//                   ],
//                 ),
//               );
//             });
//     }
//   }
//
//
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         children: <Widget>[
//           ListTile(
//             leading: profileImgUrl == ' ' || profileImgUrl == null
//                 ? Icon(Icons.account_circle_outlined, size: 50)
//                 : ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 clipBehavior: Clip.hardEdge,
//                 child:
//                 Image.network(profileImgUrl, height: 50, width: 50)),
//
//             trailing: PopupMenuButton<String>(
//               // enabled: record.id == FirebaseAuth.instance.currentUser.uid,
//                 onSelected: handleClick,
//                 itemBuilder: (BuildContext context) {
//                   print(id+' '+idPost);
//                   return {'Elimina commento'}
//                       .map((String choice) {
//                     return PopupMenuItem<String>(
//
//                         enabled: id == FirebaseAuth.instance.currentUser.uid || idPost==FirebaseAuth.instance.currentUser.uid, //se sono l'autore del post o l'autore del commento
//
//                         value: choice, child: Text(choice));
//                   }).toList();
//                 }),
//             title: Text(
//               record['nameProfile'],
//               textScaleFactor: 1.2,
//             ),
//             onTap: () {
//               FirebaseFirestore.instance.collection('subscribers').doc(record['id']).get().then((value) {
//                 UserMB user = UserMB.fromSnapshot(value);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => MyProfile(user)),//.nameProfile, record.id.toString())),
//                 );
//               });
//
//
//             },
//             // trailing: Wrap(
//             //   children: <Widget>[
//             //     IconButton(icon: Icon(Icons.thumb_up) , onPressed: null),
//             //     IconButton(icon: Icon(Icons.thumb_down), onPressed: null,)
//             //   ],
//           ),
//           Column(
//             children: <Widget>[
//               ListTile(
//                 title: Text(text),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Flexible(
//                       child: IconButton(
//                         icon: Icon(Icons.thumb_up),
//                         color: votatoLike ? Colors.green : Colors.grey,
//                         onPressed: () {
//                           setState(() {
//                             if (!votatoLike && !votatoDislike) {
//                               upvote++;
//                               // record.updateData({'upvote': upvote});
//                               comments.remove(record);
//                               record['upvote'] = upvote;
//                               record['idVotersLike']
//                                   .add(FirebaseAuth.instance.currentUser.uid);
//                               print(record);
//                               comments.add(record);
//                               reference.update({'comments': comments});
//                               votatoLike = true;
//                             } else if (votatoLike && !votatoDislike) {
//                               upvote--;
//                               // reference.updateData({'upvote': upvote});
//                               comments.remove(record);
//                               record['upvote'] = upvote;
//                               record['idVotersLike']
//                                   .remove(FirebaseAuth.instance.currentUser.uid);
//                               print(record);
//                               comments.add(record);
//                               reference.update({'comments': comments});
//                               votatoLike = false;
//                             }
//                           });
//                         },
//                       )),
//                   Flexible(
//                     child: Text((upvote - downvote).toString()),
//                   ),
//                   Flexible(
//                       child: IconButton(
//                         color: votatoDislike ? Colors.red : Colors.grey,
//                         icon: Icon(Icons.thumb_down),
//                         onPressed: () {
//                           // setState(() {
//                             if (!votatoDislike && !votatoLike) {
//                               downvote++;
//                               comments.remove(record);
//                               record['downvote'] = downvote;
//                               record['idVotersDislike']
//                                   .add(FirebaseAuth.instance.currentUser.uid);
//                               print(record);
//                               comments.add(record);
//                               reference.update({'comments': comments});
//                               votatoDislike = true;
//                             } else if (votatoDislike && !votatoLike) {
//                               downvote--;
//                               comments.remove(record);
//                               record['downvote'] = downvote;
//                               record['idVotersDislike']
//                                   .remove(FirebaseAuth.instance.currentUser.uid);
//                               print(record);
//                               comments.add(record);
//                               reference.update({'comments': comments});
//                               // record.update({'comments': record});
//                               votatoDislike = false;
//                             }
//                           // });
//                         },
//                       )),
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     ),
//   );
// }
