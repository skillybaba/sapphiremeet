import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:application/services/conferenceservice.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard/clipboard.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Confrence extends StatefulWidget {
  List check;
  Confrence({List check}) {
    this.check = check;
  }
  @override
  _ConfrenceState createState() => _ConfrenceState(check: check);
}

class _ConfrenceState extends State<Confrence> {
  List check;
  var details;
  _ConfrenceState({List check}) {
    this.check = check;
    this.details = details;
  }
  TextEditingController controller = TextEditingController();
  void initState() {
    super.initState();
    check[0] = 3232;
  }

  TextEditingController meetingname = TextEditingController();
  TextEditingController pass = TextEditingController();
  List randoms = [
    1212,
    212342,
    2121,
    412312,
    1231212,
    41212,
    'cds1212312',
    1412,
    1212,
    1212,
    212,
    31,
    'cxds',
    4233312,
    2,
    2,
    2,
    2,
    2,
    2,
    4,
    423,
    3,
    4,
    55,
    3,
    2,
    3,
    4,
    54,
    23,
    4,
    5,
    3,
    2,
    3,
    4,
    5,
    3,
    2,
    3,
    54,
    5,
    3121,
    212,
    212,
    12,
    12,
    12,
    43,
    12,
    132,
    41,
    2,
    12,
    13212,
    21,
    2,
    123,
    41,
    21,
    21,
    212,
    12,
    12,
    21,
    'cdscdsc',
    32323,
    645,
    809211,
    329842,
    738792,
    38383292092,
    494939,
    'cdscdsc',
    '4343',
    434343,
  ];
  SharedPreferences pref;
  void getPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {});
  }

  String butval = 'next';
  String nameidval = '';
  DateTime datetime;
  TimeOfDay time;
 
  @override
  Widget build(BuildContext context) {
    if (pref == null) getPref();

    if (pref != null) {
      details = pref.getStringList('your info');
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            FlatButton.icon(
              onPressed: () async {
                await showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Enter Meeting Details'),
                        content: Container(
                          height: 330,
                          child: Column(
                            children: [
                              TextField(
                                controller: meetingname,
                                decoration: InputDecoration(
                                    hintText: 'Enter the topic'),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: pass,
                                decoration: InputDecoration(
                                    hintText: 'Enter the Passcode'),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FlatButton.icon(
                                onPressed: () async {
                                  datetime = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2020),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100));
                                },
                                icon: Icon(Icons.date_range),
                                label: Text('Enter Date'),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FlatButton.icon(
                                onPressed: () async {
                                  time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                },
                                icon: Icon(Icons.timelapse_outlined),
                                label: Text('Enter Time'),
                              ),
                              Text(nameidval),
                            ],
                          ),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          '''Invite by clicking on the share button ''' 
                                              
                                        ),
                                      
                                        actions: [
                                          IconButton(
                                              icon: Icon(Icons.share_outlined),
                                              onPressed: () {
                                                ShareExtend.share(
                                                    '''${pref.getStringList('your info')[1]}  is inviting you to a scheduled Sapphire Meet . 
                Topic:${meetingname.text}
                Date:${datetime.day} ${datetime.month} ${datetime.year}
               Time: ${time.hour}:${time.minute}  
                Join Sapphire Meet
               Meeting ID: ${randoms[meetingname.text.length].toString() + meetingname.text}
                Passcode: ${pass.text}''',
                                                    'text');
                                              }),
                                          FlatButton(
                                            onPressed: () async {
                                              await Conf_Service(
                                                roomid: randoms[meetingname
                                                            .text.length]
                                                        .toString() +
                                                    meetingname.text,
                                                subject:
                                                    "subject:" + meetingname.text,
                                                username: details[0]
                                                        .replaceAll("+", "") +
                                                    " " +
                                                    details[1],
                                              ).hostMeet();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Host a Meeting'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(butval))
                        ],
                      );
                    });
              },
              icon:
                  Icon(Icons.meeting_room, color: Colors.yellow[800], size: 40),
              label: Text(
                'Host A Meeting',
                style: TextStyle(
                    color: Colors.yellow[800],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'OR',
              style: TextStyle(
                  color: Colors.yellow[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      hintText: 'Enter the Meeting Code here to Join'),
                )),
            SizedBox(
              height: 10,
            ),
            FlatButton.icon(
                onPressed: () async {
                  try {
                    await Firebase.initializeApp();
                    FirebaseFirestore ref = FirebaseFirestore.instance;
                    var doc = ref.doc('meetings/SjVi5S7Qyj3iTqwFn6Od');
                    var docdata = await doc.get();
                    if (docdata.data()[controller.text] == null)
                      Alert(
                              context: context,
                              type: AlertType.error,
                              title: "Sorry No room registered on this name")
                          .show();
                    else {
                      if (docdata.data()[controller.text.trim()]['current'] <=
                          docdata.data()[controller.text.trim()]['max'])
                        await Conf_Service(
                          roomid: controller.text.trim(),
                          username:
                              details[0].replaceAll("+", "") + " " + details[1],
                          type: 'join',
                          confinfo: docdata.data(),
                        ).hostMeet();
                      else
                        Alert(
                                context: context,
                                type: AlertType.error,
                                title:
                                    'Max Participants Reached into this Room')
                            .show();
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                icon:
                    Icon(Icons.merge_type, color: Colors.yellow[800], size: 40),
                label: Text('Join',
                    style: TextStyle(
                        color: Colors.yellow[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      );
    } else
      return SpinKitRipple(color: Colors.yellow[800]);
  }
}
