import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toast/toast.dart';

class ChatPannel extends StatefulWidget {
  @override
  _ChatPannelState createState() => _ChatPannelState();
}

class _ChatPannelState extends State<ChatPannel> {
  Map data;
  var info;
  bool isloading = false;
  bool flag = false;
  GlobalKey<DashChatState> key = GlobalKey<DashChatState>();
  List<ChatMessage> message = [];
  messages() async {
    print(data['number']);
    print(data['docid']);
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
        }
        setState(() {
          flag = true;
        });
        print('kan');
      } catch (e) {
        print(e);
      }
    }
  }

  bool checkcall = false;
  void checkCall(context, data) async {
    var check = data['check'];
    checkcall = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var info = pref.getStringList('your info');
    await Firebase.initializeApp();
    var doc = FirebaseFirestore.instance;
    var ref = doc.doc(info[2]);
    while (check[0] == 1) {
      var dataref = await ref.get();
      var data1 = dataref.data();
      print('allcool');
      print(check);
      if ((check[0] == 1) &&
          ((data1['receving'] != null) && (data1['receving'])) &&
          (((data1['calling'] == null) || (!data1['calling'])) &&
              ((data1['connected'] == null) || (!data1['connected'])))) {
        Navigator.pushNamed(context, '/caller', arguments: {
          'number': data1['caller'][0],
          'type': 'receving',
          'recever': data1['caller'][2],
          'caller': info[2],
          'check': check,
        });

        check[0] = 2;
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
              user: ChatUser(
                  name: data1[data1.length - 1]['val'][3].substring(3))));
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
    var docdata = await ref.get();
    messagedata = docdata.data()[data['number']];
    var docdata2 = await ref2.get();

    print(messagedata);
    if (messagedata == null) {
      await ref.update({
        data['number']: {
          'name': data['number'],
          'docid': data['docid'],
          'avtar': docdata2.data()['downloadablelink'] != null
              ? docdata2.data()['downloadablelink']
              : null,
          'message': []
        }
      });
      await ref2.update({
        info[0]: {
          'name': info[1],
          'docid': info[2],
          'avtar': docdata.data()['downloadablelink'] != null
              ? docdata.data()['downloadablelink']
              : null,
          'message': []
        }
      });
    } else {
      var map1 = docdata.data()[data['number']];
      var map2 = docdata2.data()[info[0]];
      map1['avtar'] = docdata2.data()['downloadablelink'] != null
          ? docdata2.data()['downloadablelink']
          : null;
      map2['avtar'] = docdata.data()['downloadablelink'] != null
          ? docdata.data()['downloadablelink']
          : null;
      ref.update({data['number']: map1});
      ref2.update({info[0]: map2});
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
    if (!checkcall) checkCall(context, data);
    if (!flag3) check();
    messages();
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                  Toast.show("Connecting Call Plz Wait", context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white);

                  await Firebase.initializeApp();
                  var firestore = FirebaseFirestore.instance;
                  var doc = firestore.doc(data['docid']);
                  var doc2 = firestore.doc(info[2]);
                  var ref2 = await doc.get();
                  var data2 = ref2.data();
                  var ref = await doc2.get();
                  print(data['docid']);
                  var data1 = ref.data();
                  if (((data1['receving'] == null) || (!data1['receving'])) &&
                      ((data1['connected'] == null) || (!data1['connected']))) {
                    print((data['number'].substring(1) + info[0].substring(1)));
                    await doc.update({
                      'receving': true,
                      'caller': info,
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1)),
                    });
                    await doc2.update({
                      'calling': true,
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1))
                    });
                    List caller = data1['callhis'];
                    List recever = data2['callhis'];
                    print(recever);
                    if (caller == null) caller = [];
                    if (recever == null) recever = [];
                    caller.add({
                      'type': 'calling',
                      'number': data['number'],
                      'name': data['name'],
                      'docid': data['docid'],
                    });
                    recever.add({
                      'type': 'receving',
                      'number': info[0],
                      'name': info[1],
                      'docid': info[2],
                    });
                    setState(() {
                      isloading = false;
                    });
                    Navigator.pushNamed(context, '/caller', arguments: {
                      'number': data['number'],
                      'type': 'calling',
                      'recever': data['docid'],
                      'caller': info[2],
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1)),
                      'check': [2],
                    });
                    doc.update({
                      'callhis': recever,
                    });
                    doc2.update({
                      'callhis': caller,
                    });
                  } else {
                    Navigator.pushNamed(context, '/caller', arguments: {
                      'number': data['number'],
                      'type': 'buzy',
                      'recever': data['docid'],
                      'caller': info[2],
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1)),
                      'check': [2]
                    });
                    doc2.update({
                      'calling': true,
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1))
                    });
                    setState(() {
                      isloading = false;
                    });
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: () async {
                  await Future.delayed(Duration(seconds: 3));
                  print('kjcds');
                },
              ),
              SizedBox(width: 10)
            ],
            leading: FlatButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/home');
                data['check'][0] = 0;
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(data['name']),
            backgroundColor: Colors.yellow[800]),
        body: LoadingOverlay(
          child: StreamBuilder(builder: (context, snapshot) {
            if (flag) {
              retrive();
              return DashChat(
                key: key,
                onQuickReply: (chatmessage) async {
                  try {
                    print(info);
                    await Firebase.initializeApp();
                    FirebaseFirestore firestore = FirebaseFirestore.instance;

                    var ref = firestore.doc(info[2]);
                    var ref2 = firestore.doc(data['docid']);
                    Map messagedata;
                    Map messagedata1;
                    await ref.get().then((value) {
                      messagedata = value.data()[data['number']];
                    });
                    await ref2.get().then((value) {
                      messagedata = value.data()[info[0]];
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

                    messagedata['message'].add({
                      'val': [
                        chatmessage.title,
                        null,
                        null,
                        info[0],
                        DateTime.now().toString(),
                      ]
                    });
                    messagedata1['message'].add({
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
                    await ref2.update({info[0]: messagedata1});
                    setState(() {
                      print('done');
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                messages: message,
                onSend: (ChatMessage chatmessage) {
                  Function msg = () async {
                    String msg = chatmessage.text;
                    String img = chatmessage.image;
                    chatmessage.text = null;
                    chatmessage.image = null;
                    try {
                      print(info);
                      await Firebase.initializeApp();
                      FirebaseFirestore firestore = FirebaseFirestore.instance;

                      var ref = firestore.doc(info[2]);
                      var ref2 = firestore.doc(data['docid']);
                      Map messagedata;
                      Map messagedata1;
                      await ref.get().then((value) {
                        messagedata = value.data()[data['number']];
                      });
                      await ref2.get().then((value) {
                        messagedata1 = value.data()[info[0]];
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

                      messagedata['message'].add({
                        'val': [
                          msg,
                          img,
                          chatmessage.user.uid,
                          info[1],
                          DateTime.now().toString(),
                        ]
                      });
                      messagedata1['message'].add({
                        'val': [
                          msg,
                          img,
                          chatmessage.user.uid,
                          info[1],
                          DateTime.now().toString(),
                        ]
                      });
                      print(messagedata);
                      await ref.update({data['number']: messagedata});
                      await ref2.update({info[0]: messagedata1});
                      setState(() {
                        print('done');
                      });
                    } catch (e) {
                      print(e);
                    }
                  };
                  msg();
                },
                user: ChatUser(
                  firstName: 'vfdvanks',
                ),
              );
            } else
              return SpinKitRing(
                color: Colors.yellow[800],
              );
          }),
          isLoading: isloading,
          opacity: 0.3,
          progressIndicator: CircularProgressIndicator(),
        ));
  }
}
