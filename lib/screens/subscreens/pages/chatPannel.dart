import 'dart:async';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:application/models/chatmodels.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  List check;
  Chat({List check, key}) : super(key: key) {
    this.check = check;
  }
  @override
  _ChatState createState() => _ChatState(check: check);
}

class _ChatState extends State<Chat> {
  var info;
  var check;
  var image = 0;
  _ChatState({List check}) {
    this.check = check;
  }
  List chatlist = [
    ChatModel(
        number: '+918979626196',
        username: "Kanishk",
        lastmsg: 'Hello my name is someone')
  ];
  int length = 0;
  bool flag = true;
  var dataman;
  SharedPreferences pref1;
  Map infodata;

  getChats() async {
    print('onn');
    pref1 = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    print('dd');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var info = pref.getStringList('your info');
    var doc = FirebaseFirestore.instance.doc(info[2]);
    print('vfd');
   doc.snapshots().listen((event) {
     var data = event.data();
     dataman = data;
    setState(() {
     
        this.chatlist = data.keys
            .map((e) => ((e != 'name') &&
                    (e != 'number') &&
                    (e != 'DP') &&
                    (e != 'calling') &&
                    (e != 'receving') &&
                    (e != 'connected') &&
                    (e != 'caller') &&
                    (e != 'channelid') &&
                    (e != 'callhis') &&
                    (e != 'downloadablelink') &&
                    (e != 'status') &&
                    (e != 'time')&&
                    (e!="notiToken")&&
                    (data[e]!=null)
                    )
                ? ChatModel(
                    username: e,
                    number: e,
                    dp: data[e]['avatar'] != null ? data[e]['avatar'] : null,
                  )
                : 'null')
            .toList();
          
     
        while (chatlist.contains('null')) chatlist.remove('null');

   
        length = data.length;
      

    });
    });
    

    flag = false;
    
  }
  StreamSubscription<DocumentSnapshot> snap;
  bool checkcall = false;
  void checkCall(context) async {
    checkcall = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    info = pref.getStringList('your info');
    await Firebase.initializeApp();
    var doc = FirebaseFirestore.instance;
    var ref = doc.doc(info[2]);
    this.snap=ref.snapshots().listen((event) { 
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

  void initState() {
    super.initState();
    getChats();
    check[0] = 0;
  }

  void dispose() {
    super.dispose();
      this.snap.cancel();
    check[0] = 1;
  }
  void deletechat(String number) async{
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
     SharedPreferences pref = await SharedPreferences.getInstance();
    info = pref.getStringList('your info');
    
    var doc = firestore.doc(info[2]);
    doc.update({
      number:null,
    });
    
  }
  @override
  Widget build(BuildContext context) {
    if (!checkcall) checkCall(context);
    
    if (!flag)
      return CustomScrollView(
        slivers: [
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if ((chatlist.length == 0) && (index < 1)) {
                return Container(
                    padding: EdgeInsets.all(60),
                    child: Center(
                        child: Text(
                      'Welcome!!',
                      style: TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )));
              } else if ((index < chatlist.length) && (chatlist.length > 0)) {
                var name;

                if (pref1.containsKey(chatlist[index].number)) {
                  name = pref1.getStringList(chatlist[index].number)[1];
                } else {
                  name = dataman[chatlist[index].number]['name'];
                  // print(dataman[chatlist[index].number]['docid']);
                }
                // print(chatlist[index].number);
                // print(dataman[chatlist[index].number]['docid']);
                //  print(index);
                return FlatButton(
                   onLongPress: (){
                     showDialog(context: context,builder: (context)=>AlertDialog(actions: [FlatButton(child: Text("Delete"),onPressed: (){
                       Navigator.pop(context);
                       this.deletechat(chatlist[index].number);
                      
                     },),FlatButton(child:Text("Back"),onPressed: (){
                       Navigator.pop(context);

                     },)],));
                   },
                    onPressed: () {
                      check[0] = 1;
                      Navigator.popAndPushNamed(context, '/chatpannel',
                          arguments: {
                            'number': chatlist[index].number,
                            'docid': dataman[chatlist[index].number]['docid'],
                            'name': name,
                            'check': check,
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              chatlist[index].dp != null
                                  ? CircularProfileAvatar('',
                                      radius: 20,
                                      child: Image(
                                        image: NetworkImage(chatlist[index].dp),
                                      ))
                                  : Icon(
                                      Icons.supervised_user_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                              SizedBox(width: 10),
                              Text(
                                '$name',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                '${chatlist[index].number}',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ));
              }
            }),
          )
        ],
      );
    else
      return SpinKitFadingCircle(color: Colors.yellow[800]);
  }
}
