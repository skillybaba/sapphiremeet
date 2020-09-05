import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:application/models/chatmodels.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List chatlist = <ChatModel>[
    ChatModel(
        number: '+918979626196',
        username: "Kanishk",
        lastmsg: 'Hello my name is someone')
  ];
  int length = 0;
  bool flag = true;
  SharedPreferences pref1;
  getChats() async {
    pref1 = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var info = pref.getStringList('your info');
    var doc = await FirebaseFirestore.instance.doc(info[2]).get();
    var data = doc.data();
    if (data.length > length)
      setState(() {
        this.chatlist = data.keys
            .map((e) => ((e != 'name') && (e != 'number') && (e != 'DP'))
                ? ChatModel(username: 'null', number: e)
                : 'null')
            .toList();
        print(chatlist);
        chatlist.removeAt(0);
        chatlist.removeAt(0);
        chatlist.remove('null');
        
        print(chatlist);
        flag = false;
        length = data.length;
      });
  }

  @override
  Widget build(BuildContext context) {
    getChats();
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
                var docid;
                if (pref1.containsKey(chatlist[index].number)) {
                  name = pref1.getStringList(chatlist[index].number)[1];
                  docid = pref1.getStringList(chatlist[index].number)[0];
                }
                return FlatButton(
                    onPressed: () async {
                      Navigator.popAndPushNamed(context, '/chatpannel',
                          arguments: {
                            'number': chatlist[index].number,
                            'docid': docid,
                            'name': name,
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                '$name',
                                style: TextStyle(
                                    fontSize: 20,
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
