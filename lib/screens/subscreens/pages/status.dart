import 'package:application/models/chatmodels.dart';
import 'package:application/models/statusmodel.dart';
import 'package:application/services/imageselectservice.dart';
import 'package:application/services/satutsservice.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List statuslist = [];
  List<StatusModel> models = [];
  SharedPreferences prefs;
  StatusModel currentuser = StatusModel();
  var flagfinal = false;
  makeModels() async {
    List number = [];
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('contact fetched')) {
      List names = prefs.getStringList('contact name');
      List docid = prefs.getStringList('contact docid');
      List list = prefs.getStringList('contact list');

      statuslist = [list, docid, names];
      print(statuslist);
      int i = 0;
      FirebaseFirestore ref = FirebaseFirestore.instance;

      while (i < statuslist[0].length) {
        var dbref = ref.doc(statuslist[1][i]);
        var docref = await dbref.get();
        var data = docref.data()['status'];
        if (!number.contains(statuslist[0][i]))
          models.add(StatusModel(
              name: statuslist[2][i],
              docid: statuslist[1][i],
              link: data != null ? data : null,
              number: statuslist[0][i]));
        print(number);
        number.add(statuslist[0][i]);

        i++;
      }
    } else {
      flagfinal = true;
    }
    print(models);
    setState(() {
      flag = true;
      current = true;
    });
  }

  var current = false;
  currentModel() async {
    var info = prefs.getStringList('your info');

    var status =
        await StatusService(number: info[0], docid: info[2]).getStatus();
    currentuser.link = status;
    currentuser.docid = info[2];
    currentuser.name = info[1];
    currentuser.number = info[0];
    setState(() {
      current = false;
    });
  }

  var setstatus = true;
  var flag = false;
  @override
  Widget build(BuildContext context) {
    if (flagfinal)
      return Center(
        widthFactor: 10.0,
          child: Text(
        'Fetch the Contacts from the below floating button First',
        style: TextStyle(
            color: Colors.yellow[800],
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ));
    if (current) currentModel();
    if (!flag) makeModels();
    if (flag)
      return CustomScrollView(
        slivers: [
          SliverList(delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index == 0)
              return FlatButton(
                  onPressed: () {
                    var image;
                    var info = prefs.getStringList('your info');
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('From'),
                        actions: [
                          FlatButton(
                              onPressed: () async {
                                image = await ImageSelect(
                                        context: context, selecttype: 'camera')
                                    .image();
                                Navigator.pop(context);
                                setState(() {
                                  setstatus = false;
                                });

                                await StatusService(
                                        number: info[0],
                                        docid: info[2],
                                        status: image)
                                    .setStatus();
                                setState(() {
                                  setstatus = true;
                                  current = true;
                                });
                              },
                              child: Text('From Camera')),
                          FlatButton(
                              onPressed: () async {
                                image = await ImageSelect(
                                  context: context,
                                ).image();
                                Navigator.pop(context);
                                setState(() {
                                  setstatus = false;
                                });

                                await StatusService(
                                        number: info[0],
                                        docid: info[2],
                                        status: image)
                                    .setStatus();
                                setState(() {
                                  setstatus = true;
                                  current = true;
                                });
                              },
                              child: Text('From Gallery'))
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        currentuser.link != null
                            ? !setstatus
                                ? Icon(Icons.data_usage_rounded,
                                    color: Colors.yellow[800], size: 60)
                                : CircularProfileAvatar(
                                    currentuser.link,
                                    radius: 30,
                                  )
                            : SpinKitThreeBounce(color: Colors.yellow[800]),
                        SizedBox(
                          width: 10,
                        ),
                        !setstatus
                            ? currentuser.link == null
                                ? Text(
                                    'Set Status',
                                    style: TextStyle(
                                        color: Colors.yellow[800],
                                        fontSize: 20),
                                  )
                                : Text(
                                    'change Status',
                                    style: TextStyle(
                                        color: Colors.yellow[800],
                                        fontSize: 20),
                                  )
                            : Text(
                                'Change Status',
                                style: TextStyle(
                                    color: Colors.yellow[800], fontSize: 20),
                              ),
                      ],
                    ),
                  ));
            else if (index < models.length)
              return FlatButton(
                  onPressed: () async {
                    if(models[index].link!=null)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Image.network(models[index].link),
                            title: Text(models[index].name),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'))
                            ],
                          );
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                          ),
                          models[index].link == null
                              ? Icon(Icons.data_usage,
                                  size: 40, color: Colors.yellow[800])
                              : CircularProfileAvatar(
                                  models[index].link,
                                  radius: 20,
                                ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            '${models[index].name}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.yellow[800]),
                          ),
                        ],
                      )));
          })),
        ],
      );
    else
      return SpinKitPulse(color: Colors.yellow[800]);
  }
}
