import 'package:flutter/material.dart';
import 'package:application/models/callingmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import "dart:async";
class Calling extends StatefulWidget {
  List check;
  Calling({List check}) {
    this.check = check;
  }
  @override
  _CallingState createState() => _CallingState(check: check);
}

class _CallingState extends State<Calling> {
  List check;
  _CallingState({List check}) {
    this.check = check;
  }
  List info;
  bool isloading = false;

  var reflist;
  List<CallingModel> callinglist = <CallingModel>[];
  Future<bool> getData() async {
    await Firebase.initializeApp();
    SharedPreferences pref = await SharedPreferences.getInstance();
    info = pref.getStringList('your info');
    var ref = FirebaseFirestore.instance;
    var doc = ref.doc(info[2]);
    this.snap = doc.snapshots().listen((event) {  
     var data = event.data()['callhis'];
    callinglist = [];
    reflist = {};
    if (data != null)
      for (var i in data) {
        if (!reflist.keys.contains(i['number']))
          callinglist.add(CallingModel(
              name: i['name'],
              docid: i['docid'],
              number: i['number'],
              type: i['type']));
        if (reflist.containsKey(i['number']))
          reflist[i['number']]++;
        else
          reflist[i['number']] = 1;
       
      }
    setState(() {
      if (!flag) flag = true;
     
    });
    });
   
    return true;
  }
  StreamSubscription<DocumentSnapshot> snap;
    StreamSubscription<DocumentSnapshot> snap2;
  void checkCall(context) async {
    this.call=false;
    SharedPreferences pref = await SharedPreferences.getInstance();
    info = pref.getStringList('your info');
    await Firebase.initializeApp();
    var doc = FirebaseFirestore.instance;
    var ref = doc.doc(info[2]);
   this.snap2=ref.snapshots().listen((event) { 
       var data1 = event.data();
      print('allcool');
    
      if (
          ((data1['receving'] != null) && (data1['receving'])) &&
          (((data1['calling'] == null) || (!data1['calling'])) &&
              ((data1['connected'] == null) || (!data1['connected'])))) {
        Navigator.pushNamed(context, '/caller', arguments: {
          'number': data1['caller'][0],
          'type': 'receving',
          
          'recever': data1['caller'][2],
          'caller': info[2],
          'check': check,
          'channelid': data1['channelid']
        });

        check[0] = 3;
      }});
     
    
  }
  bool call=true;
  bool flag = false;
  void initState() {
    super.initState();
    
 
    getData();
  }
 void dispose()
 {
  super.dispose();
  this.snap.cancel();
  this.snap2.cancel();
 }
  @override
  Widget build(BuildContext context) {
  if(this.call)this.checkCall(context);
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
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.yellow[800]),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${callinglist[index].name}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                           SizedBox(
                            width: 30,
                          ),
                           Text(reflist[callinglist[index].number].toString()+' Call',
                              style: TextStyle(color: Colors.white,fontSize: 15,)),
                         
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                              size:15,
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
                                setState(() {
                                  isloading = false;
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
