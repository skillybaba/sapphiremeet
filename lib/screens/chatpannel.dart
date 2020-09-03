import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPannel extends StatefulWidget {
  @override
  _ChatPannelState createState() => _ChatPannelState();
}

class _ChatPannelState extends State<ChatPannel> {
  Map data;
  var info;
  bool flag = false;
  GlobalKey<DashChatState> key = GlobalKey<DashChatState>();
  List<ChatMessage> message = [];
  messages() async {
    if (!flag) {
      try {
        data = ModalRoute.of(context).settings.arguments;
        await Firebase.initializeApp();
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        SharedPreferences pref = await SharedPreferences.getInstance();
        info = pref.getStringList('your info');
        print(info);
        var doc = firestore.doc(info[2]);
        var data1 = await doc.get();
        Map chats = data1.data();
        print(chats);
        if (chats.containsKey(data['number'])) {
          var data1 = chats[data['number']]['message'];
          this.message = [];

          for (var i in data1)
            this.message.add(ChatMessage(
                quickReplies: i['val'][0] == 'hi'
                    ? QuickReplies(values: [Reply(title: 'hello')])
                    : null,
                text: i['val'][0],
                user: ChatUser(name: i['val'][3].substring(3))));
          print(message);

          setState(() {
            flag = true;
          });
        }
        setState(() {
          flag = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  int prevlength;
  void retrive() async {
    prevlength = message.length;
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = firestore.doc(info[2]);
    var docref = await doc.get();
    var data2 = docref.data();
    if (data2.containsKey(data['number'])) {
      var data1 = data2[data['number']]['message'];
      setState(() {
        if (prevlength != data1.length) {
          prevlength = data1.length;

          this.message.add(ChatMessage(
              text: data1[data1.length - 1]['val'][0],
              user: ChatUser(name: data1[data1.length - 1]['val'][3].substring(3))));
        }
      });
    }
  }

  bool flag3 = false;
  void check() async {
    data = ModalRoute.of(context).settings.arguments;
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
      await ref.update({
        data['number']: {
          'name': data['number'],
          'docid': data['docid'],
          'message': []
        }
      });
      await ref2.update({
        info[0]: {'name': data['number'], 'docid': data['docid'], 'message': []}
      });
    }
    setState(() {
      flag3 = true;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if (!flag3) check();
    messages();
    return Scaffold(
        appBar: AppBar(
            leading: FlatButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/home');
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text('Sapphire Meet'),
            backgroundColor: Colors.yellow[800]),
        body: StreamBuilder(builder: (context, snapshot) {
          if (flag) {
            retrive();
            return DashChat(
              key: key,
              onQuickReply: (chatmessage) async{
                try {
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
                  // if (messagedata == null) {
                  //   await ref.update({
                  //     data['number']: {
                  //       'name': data['number'],
                  //       'docid': data['docid'],
                  //       'message': []
                  //     }
                  //   });
                  //   await ref2.update({
                  //     info[0]: {
                  //       'name': data['number'],
                  //       'docid': data['docid'],
                  //       'message': []
                  //     }
                  //   });
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.setString(data['number'], data['docid']);

                  messagedata['message'].add({
                    'val': [
                      chatmessage.title,
                      null,
                      null,
                      info[0],
                      DateTime.now().toString(),
                    ]
                  });
                  print(messagedata);
                  await ref.update({data['number']: messagedata});
                  await ref2.update({info[0]: messagedata});
                  setState(() {
                    print('done');
                  });
                } catch (e) {
                  print(e);
                }
              },
              messages: message,
              onSend: (ChatMessage chatmessage) async {
                try {
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
                  // if (messagedata == null) {
                  //   await ref.update({
                  //     data['number']: {
                  //       'name': data['number'],
                  //       'docid': data['docid'],
                  //       'message': []
                  //     }
                  //   });
                  //   await ref2.update({
                  //     info[0]: {
                  //       'name': data['number'],
                  //       'docid': data['docid'],
                  //       'message': []
                  //     }
                  //   });
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.setString(data['number'], data['docid']);

                  messagedata['message'].add({
                    'val': [
                      chatmessage.text,
                      chatmessage.image,
                      chatmessage.user.uid,
                      info[0],
                      DateTime.now().toString(),
                    ]
                  });
                  print(messagedata);
                  await ref.update({data['number']: messagedata});
                  await ref2.update({info[0]: messagedata});
                  setState(() {
                    print('done');
                  });
                } catch (e) {
                  print(e);
                }
              },
              user: ChatUser(
                firstName: 'vfdvanks',
              ),
            );
          } else
            return SpinKitRing(
              color: Colors.yellow[800],
            );
        }));
  }
}
