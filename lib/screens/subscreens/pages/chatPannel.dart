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
  List<ChatModel> chatlist = <ChatModel>[
    ChatModel(
        number: '+918979626196',
        username: "Kanishk",
        lastmsg: 'Hello my name is someone')
  ];
  bool flag = true;
  getChats() async {
    await Firebase.initializeApp();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var info = pref.getStringList('your info');
    var doc = await FirebaseFirestore.instance.doc(info[2]).get();
    var data = doc.data();
    if (flag)
      setState(() {
        this.chatlist = data.keys
            .map((e) => ((e != 'name') && (e != 'number'))
                ? ChatModel(username: 'null', number: e)
                : ChatModel(username: 'null', number: 'null'))
            .toList();
        print(chatlist);
        chatlist.removeAt(0);
        chatlist.removeAt(0);
        print(chatlist);
        flag = false;
      });
    setState(() {});
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
              if ((chatlist.length == 0) && (index < 1))
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
              else if (index < chatlist.length) {
                print(chatlist[index].number);
                return FlatButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      var docid = pref.getString(chatlist[index].number);
                      print(docid);
                      Navigator.popAndPushNamed(context, '/chatpannel',
                          arguments: {
                            'number': chatlist[index].number,
                            'docid': docid
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
                                '${chatlist[index].username}',
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
