// import 'package:flutter/material.dart';
//
// Widget Comment(){
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
//                           setState(() {
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
//                           });
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