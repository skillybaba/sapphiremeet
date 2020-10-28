import 'package:flutter/material.dart';
import 'package:application/services/conferenceservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:Container(
        child: Column(
      children: [
        SizedBox(height: 90),
        Image.asset(
          'assests/images/4802.jpg',
          height: 260,
        ),
        Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
                'Join Meeting As a Guest Enter the Valid Meeting Code Below',
                style: TextStyle(
                    color: Colors.yellow[800],
                    fontSize: 25,
                    fontWeight: FontWeight.bold))),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.only(left: 30, right: 50),
          child: TextField(
            controller: controller,
            autocorrect: true,
           
            decoration: InputDecoration(
                labelText: 'Enter the Meeting Code',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
        ),
        SizedBox(height: 10),
        FlatButton.icon(
            onPressed: () async {
              try {
                await Firebase.initializeApp();
                    FirebaseFirestore ref = FirebaseFirestore.instance;
                    var doc = ref.doc('meetings/SjVi5S7Qyj3iTqwFn6Od');
                    var docdata = await doc.get();
                    if (docdata.data()[controller.text.trim()]['current'] <=
                        docdata.data()[controller.text.trim()]['max'])
                await Conf_Service(
                  roomid: controller.text.trim(),
                  username: 'Random Person',
                  type:'join',
                ).hostMeet();
                else
                      Alert(
                              context: context,
                              type: AlertType.error,
                              title: 'Max Participants Reached into this Room')
                          .show();
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
            icon: Icon(Icons.group_add, color: Colors.yellow[800]),
            label:
                Text('JOIN NOW', style: TextStyle(color: Colors.yellow[800])))
      ],
    )));
  }
}
