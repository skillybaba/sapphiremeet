import 'package:application/services/callingservice.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class Call extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  Map info;
  bool audioflag = true;
  var player = AudioPlayer();
  audio() async {
    if (info['type'] == 'receving') {
      await player.setLoopMode(LoopMode.one);
      await player.setAsset('assests/audio/rec.wav');
      await player.play();
    } else {
      await player.setLoopMode(LoopMode.one);
      await player.setAsset('assests/audio/send.wav');
      await player.setVolume(0.02);
      await player.play();
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
      ref.update({
        'connected': false,
        'calling': false,
        'receving': false,
      });
      if ((data2['connected'] == null) || (!data2['connected']))
        ref2.update({
          'connected': false,
          'calling': false,
          'receving': false,
        });
    } else if (info['type'] == 'buzy') {
      print(data);
      ref.update({
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
    player.dispose();
  }

  bool nn = false;
  @override
  Widget build(BuildContext context) {
    info = ModalRoute.of(context).settings.arguments;
    audio();
    if (!nn) checkall(info);
    nn = true;
    action(info, context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: SweepGradient(
          stops: [0.0, 0.25, 0.5, 0.75, 1],
          colors: [
            Colors.blue,
            Colors.yellow,
            Colors.green,
            Colors.red,
            Colors.blue
          ],
        )),
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
                : Text(
                    info['number'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Ringing....',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 50,
            ),
            info['image'] == null
                ? Icon(Icons.account_circle_rounded, size: 140)
                : CircularProfileAvatar(
                    info['image'],
                    radius: 130,
                    borderWidth: 2,
                    borderColor: Colors.black,
                  ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                info != null && info['type'] == 'receving'
                    ? SizedBox(
                        width: 100,
                      )
                    : SizedBox(
                        width: 180,
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
