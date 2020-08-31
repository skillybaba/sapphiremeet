import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPannel extends StatefulWidget {
  @override
  _ChatPannelState createState() => _ChatPannelState();
}

class _ChatPannelState extends State<ChatPannel> {
  Map data;
  var info;
  GlobalKey<DashChatState> key = GlobalKey<DashChatState>();
  var message = [
    ChatMessage(text: 'klan', user: ChatUser(firstName: 'kanishk')),
    ChatMessage(text: 'new', user: ChatUser(firstName: 'kanishk'))
  ];
  StreamController streamController = StreamController();
  messages(user1, user2, context) async {
    data = ModalRoute.of(context).settings.arguments;
    await Firebase.initializeApp();
    List chats;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ref = firestore.collection('msg');
  }

  Widget initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
            title: Text('Sapphire Meet'), backgroundColor: Colors.yellow[800]),
        body: StreamBuilder(builder: (context, snapshot) {
          return DashChat(
            key: key,
            messages: message,
            onSend: (ChatMessage chatmessage) async {
              try {
                SharedPreferences pref = await SharedPreferences.getInstance();
                info = pref.getStringList('your info');
                print(info);
                await Firebase.initializeApp();
                FirebaseFirestore firestore = FirebaseFirestore.instance;

                var ref = firestore.doc(info[2]);
                var ref2 = firestore.doc(data['docid']);
                Map messagedata;
                await ref.get().then((value) {
                  messagedata = value.data()[data['number']];
                });
                print(messagedata);
                if (messagedata == null) {
                  ref.update({
                    data['number']: {'name': data['number'], 'message': []}
                  });
                  ref2.update({
                    info[0]: {'name': data['number'], 'message': []}
                  });
                } else {
                  messagedata['message'].add({
                    DateTime.now().toString(): [ chatmessage.text,chatmessage.image]
                  });
                  print(messagedata);
                  await ref.update({data['number']: messagedata});
                  await ref2.update({info[0]: messagedata});
                }
              } catch (e) {
                print(e);
              }
            },
            user: ChatUser(firstName: 'vfdvanks'),
          );
        }));
  }
}
