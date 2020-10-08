import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toast/toast.dart';
import '../services/imageselectservice.dart';
import '../services/firebasedatabse.dart';

class ChatPannel extends StatefulWidget {
  @override
  _ChatPannelState createState() => _ChatPannelState();
}

class _ChatPannelState extends State<ChatPannel> {
  Map data;
  var info;
  bool isloading = false;
  bool flag = false;
  String avtar, ctavtar;
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
       
        var doc = firestore.doc(info[2]);
        var data1 = await doc.get();
        Map chats = data1.data();
       
        if (chats.containsKey(data['number'])) {
          var data1 = chats[data['number']]['message'];
          this.message = [];
          ctavtar = chats[data['number']]['avtar'];
          avtar = chats['DP'];
          for (var i in data1)
            if (i['val'][1] != null)
              this.message.add(ChatMessage(
                  image: i['val'][1],
                  text: 'images',
                  createdAt: i['val'][4].toDate(),
                  quickReplies: i['val'][0] == 'hi'
                      ? QuickReplies(values: [Reply(title: 'hello')])
                      : null,
                  user: ChatUser(
                      avatar: i['val'][3] == info[1] ? avtar : ctavtar,
                      name: i['val'][3])));
            else if (i['val'][2] != null)
              this.message.add(ChatMessage(
                  video: i['val'][2],
                  text: 'images',
                  createdAt: i['val'][4].toDate(),
                  quickReplies: i['val'][0] == 'hi'
                      ? QuickReplies(values: [Reply(title: 'hello')])
                      : null,
                  user: ChatUser(
                      avatar: i['val'][3] == info[1] ? avtar : ctavtar,
                      name: i['val'][3])));
            else
              this.message.add(ChatMessage(
                  createdAt: i['val'][4].toDate(),
                  quickReplies: i['val'][0] == 'hi'
                      ? QuickReplies(values: [Reply(title: 'hello')])
                      : null,
                  text: i['val'][0],
                  user: ChatUser(
                      avatar: i['val'][3] == info[1] ? avtar : ctavtar,
                      name: i['val'][3])));
          
        }
        setState(() {
          flag = true;
        });
      
      } catch (e) {
        print(e);
      }
    }
  }

  bool checkcall = false;
  // void checkCall(context, data) async {
  //   var check = data['check'];
  //   checkcall = true;
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var info = pref.getStringList('your info');
  //   await Firebase.initializeApp();
  //   var doc = FirebaseFirestore.instance;
  //   var ref = doc.doc(info[2]);
  //   while (check[0] == 1) {
  //     var dataref = await ref.get();
  //     var data1 = dataref.data();
  //     print('allcool');
  //     print(check);
  //     if ((check[0] == 1) &&
  //         ((data1['receving'] != null) && (data1['receving'])) &&
  //         (((data1['calling'] == null) || (!data1['calling'])) &&
  //             ((data1['connected'] == null) || (!data1['connected'])))) {
  //       Navigator.pushNamed(context, '/caller', arguments: {
  //         'number': data1['caller'][0],
  //         'type': 'receving',
  //         'recever': data1['caller'][2],
  //         'caller': info[2],
  //         'check': check,
  //       });

  //       check[0] = 2;
  //     }
  //   }
  // }

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
        if (prevlength < data1.length) {
          prevlength = data1.length;
          if (data1[data1.length - 1]['val'][1] != null)
            this.message.add(ChatMessage(
                image: data1[data1.length - 1]['val'][1],
                createdAt: data1[data1.length - 1]['val'][4].toDate(),
                text: 'images',
                user: ChatUser(
                    avatar: data1[data.length - 1]['val'][3] == info[1]
                        ? avtar
                        : ctavtar,
                    name: data1[data1.length - 1]['val'][3])));
          else if (data1[data1.length - 1]['val'][2] != null)
            this.message.add(ChatMessage(
                video: data1[data1.length - 1]['val'][2],
                createdAt: data1[data1.length - 1]['val'][4].toDate(),
                text: 'images',
                user: ChatUser(
                    avatar: data1[data.length - 1]['val'][3] == info[1]
                        ? avtar
                        : ctavtar,
                    name: data1[data1.length - 1]['val'][3])));
          else
            this.message.add(ChatMessage(
                createdAt: data1[data1.length - 1]['val'][4].toDate(),
                text: data1[data1.length - 1]['val'][0],
                user: ChatUser(
                    avatar: data1[data.length - 1]['val'][3] == info[1]
                        ? avtar
                        : ctavtar,
                    name: data1[data1.length - 1]['val'][3])));
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

    avtar = docdata.data()['DP'];
    print(messagedata);
    if (messagedata == null) {
      await ref.update({
        data['number']: {
          'name': data['number'],
          'docid': data['docid'],
          'avtar': docdata2.data()['DP'] != null ? docdata2.data()['DP'] : null,
          'message': []
        }
      });
      await ref2.update({
        info[0]: {
          'name': info[1],
          'docid': info[2],
          'avtar': docdata.data()['DP'] != null ? docdata.data()['DP'] : null,
          'message': []
        }
      });
    } else {
      var map1 = docdata.data()[data['number']];
      var map2 = docdata2.data()[info[0]];
      map1['avtar'] =
          docdata2.data()['DP'] != null ? docdata2.data()['DP'] : null;
      map2['avtar'] =
          docdata.data()['DP'] != null ? docdata.data()['DP'] : null;
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
    // if (!checkcall) checkCall(context, data);
    if (!flag3) check();
    if (!flag) messages();
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
                      'image':ctavtar,
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
                      'image':ctavtar,
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
                messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                  return BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: msg.user.name == info[1]
                        ? Colors.yellow[800]
                        : Colors.white, // example
                  );
                },
                messageImageBuilder: (url, [chat]) {
                  return Image.network(
                    url,
                    height: 250,
                  );
                },
                messageTextBuilder: (message, [chat]) {
                  return Text(
                    message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: chat.user.name == info[1]
                            ? Colors.white
                            : Colors.yellow[800]),
                  );
                },
                dateBuilder: (date) {
                  return Text(date, style: TextStyle(color: Colors.grey[400]));
                },
                onLongPressMessage: (ChatMessage message) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Image.network(message.image);
                    },
                  );
                },
                onPressAvatar: (ChatUser user) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Image.network(user.avatar);
                      });
                },
                trailing: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Select the Media type'),
                              actions: [
                                FlatButton(
                                    child: Text('Image from gallery'),
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      var image =
                                          await ImageSelect(context: context)
                                              .image();
                                      var url = await FireBaseDataBase(
                                              number: info[0])
                                          .msgImg(image);
                                          
                                      setState(() {
                                        message.add(ChatMessage(
                                            text: 'image',
                                            image: url,
                                            user: ChatUser(
                                              avatar: avtar!=null?avtar:null,
                                              name: info[1],
                                            )));
                                      });
                                      await Firebase.initializeApp();
                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;

                                      var ref = firestore.doc(info[2]);
                                      var ref2 = firestore.doc(data['docid']);
                                      Map messagedata;
                                      Map messagedata1;
                                      await ref.get().then((value) {
                                        messagedata =
                                            value.data()[data['number']];
                                      });
                                      await ref2.get().then((value) {
                                        messagedata1 = value.data()[info[0]];
                                      });

                                      messagedata['message'].add({
                                        'val': [
                                          null,
                                          url,
                                          null,
                                          info[1],
                                          DateTime.now(),
                                        ]
                                      });
                                      messagedata1['message'].add({
                                        'val': [
                                          null,
                                          url,
                                          null,
                                          info[1],
                                          DateTime.now(),
                                        ]
                                      });
                                      print(messagedata);
                                      await ref.update(
                                          {data['number']: messagedata});
                                      await ref2
                                          .update({info[0]: messagedata1});
                                      setState(() {
                                        print('done');
                                      });
                                    }),
                                FlatButton(
                                  child: Text('Image form camera'),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var image = await ImageSelect(
                                            context: context,
                                            selecttype: 'camera')
                                        .image();
                                    var url =
                                        await FireBaseDataBase(number: info[0])
                                            .msgImg(image);
                                    
                                      message.add(ChatMessage(
                                          text: 'image',
                                          image: url,
                                          user: ChatUser(
                                            avatar: avtar!=null?avtar:null,
                                            name: info[1],
                                          )));
                               
                                    await Firebase.initializeApp();
                                    FirebaseFirestore firestore =
                                        FirebaseFirestore.instance;

                                    var ref = firestore.doc(info[2]);
                                    var ref2 = firestore.doc(data['docid']);
                                    Map messagedata;
                                    Map messagedata1;
                                    await ref.get().then((value) {
                                      messagedata =
                                          value.data()[data['number']];
                                    });
                                    await ref2.get().then((value) {
                                      messagedata1 = value.data()[info[0]];
                                    });

                                    messagedata['message'].add({
                                      'val': [
                                        null,
                                        url,
                                        null,
                                        info[1],
                                        DateTime.now(),
                                      ]
                                    });
                                    messagedata1['message'].add({
                                      'val': [
                                        null,
                                        url,
                                        null,
                                        info[1],
                                        DateTime.now(),
                                      ]
                                    });
                                    print(messagedata);
                                    await ref
                                        .update({data['number']: messagedata});
                                    await ref2.update({info[0]: messagedata1});
                                    
                                      print('done');
                            
                                  },
                                ),
                                FlatButton(
                                  child: Text('Videos'),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    var video = await ImageSelect(
                                            context: context,
                                            selecttype: 'video')
                                        .image();
                                    var url =
                                        await FireBaseDataBase(number: info[0])
                                            .msgImg(video);
                              
                                      message.add(ChatMessage(
                                          text: 'video',
                                          video: url,
                                          user: ChatUser(
                                            avatar: avtar!=null?avtar:null,
                                            name: info[1],
                                          )));
                                  
                                    await Firebase.initializeApp();
                                    FirebaseFirestore firestore =
                                        FirebaseFirestore.instance;

                                    var ref = firestore.doc(info[2]);
                                    var ref2 = firestore.doc(data['docid']);
                                    Map messagedata;
                                    Map messagedata1;
                                    await ref.get().then((value) {
                                      messagedata =
                                          value.data()[data['number']];
                                    });
                                    await ref2.get().then((value) {
                                      messagedata1 = value.data()[info[0]];
                                    });

                                    messagedata['message'].add({
                                      'val': [
                                        null,
                                        null,
                                        url,
                                        info[1],
                                        DateTime.now(),
                                      ]
                                    });
                                    messagedata1['message'].add({
                                      'val': [
                                        null,
                                        url,
                                        null,
                                        info[1],
                                        DateTime.now(),
                                      ]
                                    });
                                    print(messagedata);
                                    await ref
                                        .update({data['number']: messagedata});
                                    await ref2.update({info[0]: messagedata1});
                                    setState(() {
                                      print('done');
                                    });
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.image))
                ],
                shouldShowLoadEarlier: true,
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
                        chatmessage.title,
                        null,
                        null,
                        info[1],
                        DateTime.now(),
                      ]
                    });
                    messagedata1['message'].add({
                      'val': [
                        chatmessage.title,
                        null,
                        null,
                        info[1],
                        DateTime.now(),
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

                    chatmessage.createdAt = DateTime.now();
                    chatmessage.user.name = info[1];
                    if (avtar != null) chatmessage.user.avatar = avtar;
                    try {
                      
                        this.message.add(chatmessage);
                   

                      print(info);
                      await Firebase.initializeApp();
                      FirebaseFirestore firestore = FirebaseFirestore.instance;

                      var ref = firestore.doc(info[2]);
                      var ref2 = firestore.doc(data['docid']);
                      Map messagedata;
                      Map messagedata1;
                     
                      await ref.get().then((value) {
                        avtar = value.data()['DP'];
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
                        'val': [msg, img, null, info[1], DateTime.now()]
                      });
                      messagedata1['message'].add({
                        'val': [msg, img, null, info[1], DateTime.now()]
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
