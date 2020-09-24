import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:application/services/conferenceservice.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard/clipboard.dart';
import 'package:toast/toast.dart';

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
  TextEditingController subject = TextEditingController();
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
  ];
  SharedPreferences pref;
  void getPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {});
  }

  String butval = 'next';
  String nameidval = '';
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
                          child: Column(
                            children: [
                              TextField(
                                controller: meetingname,
                                decoration: InputDecoration(
                                    hintText: 'Enter the Nameid'),
                              ),
                              TextField(
                                controller: subject,
                                decoration: InputDecoration(
                                    hintText: 'What is your subject of meet?'),
                              ),
                              SizedBox(
                                height: 30,
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
                                          'Copy the NameId: ' +
                                              randoms[meetingname.text.length]
                                                  .toString() +
                                              meetingname.text,
                                        ),
                                        content: RaisedButton(
                                          onPressed: () {
                                            FlutterClipboard.copy(
                                              "Join into the sapphire meet with Meeting Code:"+
                                                randoms[meetingname.text.length]
                                                        .toString() +
                                                    meetingname.text);
                                            Toast.show('Copied', context);
                                          },
                                          child: Icon(Icons.share),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: () async {
                                              await Conf_Service(
                                                roomid: randoms[meetingname
                                                            .text.length]
                                                        .toString() +
                                                    meetingname.text,
                                                subject:
                                                    "subject:" + subject.text,
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
                    await Conf_Service(
                      roomid: controller.text.trim(),
                      username: details[0].replaceAll("+", "") + " " + details[1],
                    ).hostMeet();
                  } catch (e) {
                    print(e);
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Container(
                              color: Colors.yellow,
                              child: Text(
                                'Enter the Meeting code',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ));
                        });
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
