import 'package:application/services/callingservice.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

class Call extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  Map info;
  bool audioflag = true;
  audio() async {
    AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    if (info['type'] == 'receving') {
      while (audioflag)
        await audioPlayer.play(
            'https://firebasestorage.googleapis.com/v0/b/sapphire-meet.appspot.com/o/ringtone%2FUniversal-Hollywood-Phone-Ringtone.wav?alt=media&token=c30fd9be-3b47-4b86-b317-8f889712ce43');
    } else {
      while (audioflag)
        await audioPlayer.play(
            'https://firebasestorage.googleapis.com/v0/b/sapphire-meet.appspot.com/o/ringtone%2Fsalamisound-1020075-phone-call-sign-type-siemens.mp3?alt=media&token=34ed04be-5211-473f-acb5-d4d0f5f46740');
    }
  }

  void action(info, context, [end = false]) async {
    await null;
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    var ref = firestore.doc(info['caller']);
    var ref2 = firestore.doc(info['recever']);
    var val = await ref.get();

    var data = val.data();
    var val2 = await ref2.get();
    var data2 = val2.data();

    if (end) {
      await ref.update({
        'connected': false,
        'calling': false,
        'receving': false,
      });
      if ((data2['connected'] == null) || (!data2['connected']))
        await ref2.update({
          'connected': false,
          'calling': false,
          'receving': false,
        });
    } else if (info['type'] == 'buzy') {
      print(data);
      await ref.update({
        'calling': false,
      });
      print('done');
      Navigator.pop(context);
      Toast.show("User On the Other Call", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  int checkcall = 0;
  void checkall(info) async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    var ref = firestore.doc(info['caller']);

    while (checkcall == 0) {
      var val = await ref.get();
      var data = val.data();

      if (data['connected']) {
        CallingService(data['channelid'],
                caller: info['caller'],
                recever: info['recever'],
                number: info['number'])
            .connect();
        if (info['check'][0] == 3) {
          info['check'][0] = 0;
          Navigator.popAndPushNamed(context, '/home');
        } else {
          info['check'][0] = 1;
          Navigator.pop(context);
        }
        checkcall = 1;
      }
    }
  }

  void dispose() {
    super.dispose();
    audioflag = false;
  }

  bool nn = false;
  @override
  Widget build(BuildContext context) {
    audio();
    info = ModalRoute.of(context).settings.arguments;
    if (!nn) checkall(info);
    nn = true;
    action(info, context);
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            info == null
                ? Text(
                    'Unknown',
                    style: TextStyle(fontSize: 20),
                  )
                : Text(info['number']),
            SizedBox(
              height: 10,
            ),
            info['image'] == null
                ? Icon(Icons.account_circle_rounded, size: 140)
                : Image.file(info['image']),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                info != null && info['type'] == 'receving'
                    ? SizedBox(
                        width: 90,
                      )
                    : SizedBox(
                        width: 160,
                      ),
                IconButton(
                    icon: Icon(
                      Icons.call_end,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: () {
                      action(info, context, true);

                      if (info['check'][0] == 3) {
                        info['check'][0] = 0;
                        Navigator.popAndPushNamed(context, '/home');
                      } else {
                        info['check'][0] = 1;
                        Navigator.pop(context);
                      }
                      Toast.show("call ended", context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    }),
                info != null && info['type'] == 'receving'
                    ? SizedBox(
                        width: 90,
                      )
                    : SizedBox(),
                info != null && info['type'] == 'receving'
                    ? IconButton(
                        icon: Icon(Icons.call, color: Colors.green, size: 40),
                        onPressed: () async {
                          checkcall = 1;
                          await Firebase.initializeApp();
                          var firestore = FirebaseFirestore.instance;
                          var ref = firestore.doc(info['caller']);
                          var ref2 = firestore.doc(info['recever']);
                          var val = await ref.get();
                          var data = val.data();

                          CallingService(data['channelid'],
                                  caller: info['caller'],
                                  recever: info['recever'],
                                  number: info['number'])
                              .connect();
                          ref.update({
                            'connected': true,
                            'receving': false,
                            'calling': false,
                          });
                          ref2.update({
                            'connected': true,
                            'receving': false,
                            'calling': false,
                          });

                          if (info['check'][0] == 3) {
                            info['check'][0] = 0;
                            Navigator.popAndPushNamed(context, '/home');
                          } else {
                            info['check'][0] = 1;
                            Navigator.pop(context);
                          }
                        })
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
