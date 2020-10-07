import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:application/services/conferenceservice.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List data;
  bool flag = false;
  var details;
  check() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await Firebase.initializeApp();
    FirebaseFirestore fs = FirebaseFirestore.instance;
    var ref = fs.doc(pref.getString('userdocid'));
    var refdata = await ref.get();
    data = refdata.data()['roomid'];
    details = pref.getStringList('your info');
    if (data == null) data = [];
    setState(() {
      flag = true;
      data = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!flag) check();
    if (flag)
      return Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              FlatButton(
                  onPressed: () async {
                    data = [];
                    setState(() {});
                    await Firebase.initializeApp();
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    FirebaseFirestore fs = FirebaseFirestore.instance;
                    var ref = fs.doc(pref.getString('userdocid'));
                    ref.update({
                      'roomid': [],
                    });
                  },
                  child: Icon(Icons.delete,color: Colors.white,))
            ],
            backgroundColor: Colors.yellow[800],
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Meet history'),
            ),
          ),
          SliverList(delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < data.length)
              return ListTile(
                  isThreeLine: true,
                  onTap: () async {
                    await Conf_Service(
                      roomid: data[index],
                      subject: "subject:",
                      username:
                          details[0].replaceAll("+", "") + " " + details[1],
                    ).hostMeet();
                  },
                  subtitle: Text("Tap to rejoin Your Meet",
                      style: TextStyle(color: Colors.yellow[800])),
                  title: Text(
                    data[index],
                    style: TextStyle(
                        color: Colors.yellow[800], fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.merge_type,
                    color: Colors.yellow[800],
                  ));
          }))
        ],
      ));
    else
      return SpinKitDoubleBounce(
        color: Colors.yellow[800],
      );
  }
}
