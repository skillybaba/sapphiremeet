import 'package:flutter/material.dart';
import 'package:application/models/chatmodels.dart';

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
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index < chatlist.length) {
              return FlatButton(
                  onPressed: () {},
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
                            SizedBox(width:10),
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
                        SizedBox(height: 20,),
                        Row(children: [
                          Icon(Icons.check_box,color: Colors.white,size: 15,),
                          SizedBox(width: 10,),
                          Text(
                            ': ${chatlist[index].lastmsg}....',
                            style: TextStyle(color: Colors.white),
                          )
                        ])
                      ],
                    ),
                  ));
            }
          }),
        )
      ],
    );
  }
}
