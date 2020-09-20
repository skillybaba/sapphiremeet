import 'package:flutter/material.dart';
import 'package:application/models/callingmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Calling extends StatefulWidget {
  @override
  _CallingState createState() => _CallingState();
}

class _CallingState extends State<Calling> {
  List info;
  bool isloading = false;
  List<CallingModel> callinglist = <CallingModel>[];
  Future<bool> getData() async {
    await Firebase.initializeApp();
    SharedPreferences pref = await SharedPreferences.getInstance();
    info = pref.getStringList('your info');
    var ref = FirebaseFirestore.instance;
    var doc = ref.doc(info[2]);
    var getvals = await doc.get();
    var data = getvals.data()['callhis'];
    callinglist = [];
    
    if (data != null)
      for (var i in data) {
        callinglist.add(CallingModel(
            name: i['name'],
            docid: i['docid'],
            number: i['number'],
            type: i['type']));
      }
    setState(() {
      if (!flag) flag = true;
      print('done');
    });
    return true;
  }

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    getData();
    if (flag)
      return LoadingOverlay(
        child: CustomScrollView(
          slivers: [
            SliverList(delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index < callinglist.length) {
                return FlatButton(
                    onPressed: () {},
                    child: Container(
                      padding: EdgeInsets.all(30),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.yellow[800]),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Text(
                            "${callinglist[index].name}",
                            style: TextStyle(fontSize: 21, color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              setState(() {
                                isloading = true;
                              });
                              await Firebase.initializeApp();
                              var firestore = FirebaseFirestore.instance;
                              var doc = firestore.doc(callinglist[index].docid);
                              var doc2 = firestore.doc(info[2]);

                              var ref = await doc2.get();
                              var ref2 = await doc.get();
                              var data2 = ref2.data();
                              var data1 = ref.data();
                              if (((data1['receving'] == null) ||
                                      (!data1['receving'])) &&
                                  ((data1['connected'] == null) ||
                                      (!data1['connected']))) {
                                print((callinglist[index].number.substring(1) +
                                    info[0].substring(1)));
                                await doc.update({
                                  'receving': true,
                                  'caller': info,
                                  'channelid':
                                      (callinglist[index].number.substring(1) +
                                          info[0].substring(1)),
                                });
                                await doc2.update({
                                  'calling': true,
                                  'channelid':
                                      (callinglist[index].number.substring(1) +
                                          info[0].substring(1))
                                });
                                List caller = data1['callhis'];
                                List recever = data2['callhis'];
                                if (caller == null) caller = [];
                                if (recever == null) recever = [];
                                caller.add({
                                  'type': 'calling',
                                  'number': callinglist[index].number,
                                  'name': callinglist[index].name,
                                  'docid': callinglist[index].docid,
                                });

                                recever.add({
                                  'type': 'receving',
                                  'number': info[0],
                                  'name': info[1],
                                  'docid': info[2],
                                });
                                doc.update({
                                  'callhis': recever,
                                });
                                doc2.update({
                                  'callhis': caller,
                                });
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.pushNamed(context, '/caller',
                                    arguments: {
                                      'number': callinglist[index].number,
                                      'type': 'calling',
                                      'recever': callinglist[index].docid,
                                      'caller': info[2],
                                      'channelid': (callinglist[index]
                                              .number
                                              .substring(1) +
                                          info[0].substring(1)),
                                      'check': [2],
                                    });
                              } else {
                                Navigator.pushNamed(context, '/caller',
                                    arguments: {
                                      'number': callinglist[index].number,
                                      'type': 'buzy',
                                      'recever': callinglist[index].docid,
                                      'caller': info[2],
                                      'channelid': (callinglist[index]
                                              .number
                                              .substring(1) +
                                          info[0].substring(1)),
                                      'check': [2]
                                    });
                                doc2.update({
                                  'calling': true,
                                  'channelid':
                                      (callinglist[index].number + info[2])
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ));
              }
            }))
          ],
        ),
        isLoading: isloading,
        opacity: 0.3,
        progressIndicator: CircularProgressIndicator(),
      );
    else
      return SpinKitRotatingPlain(
        color: Colors.yellow[800],
      );
  }
}
