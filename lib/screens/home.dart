import 'package:application/services/firebasedatabse.dart';
import 'package:flutter/material.dart';
import './subscreens/pages/chatPannel.dart';
import './subscreens/pages/Confrence.dart';
import './subscreens/pages/calling.dart';
import './subscreens/pages/status.dart';
import 'package:application/services/authvals.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  PageController controller = PageController(initialPage: 0);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: Drawer(
        child: FlatButton.icon(
            onPressed: () async {
              await AuthVals().deleteVals('userinfo', 'auth');
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.no_encryption),
            label: Text('Logout')),
      ),
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                controller.animateToPage(3,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              child: Icon(Icons.rounded_corner, size: 30, color: Colors.white))
        ],
        bottom: PreferredSize(
            preferredSize: Size(40, 60),
            child: Row(children: [
              Container(
                  margin: EdgeInsets.only(left: 21),
                  child: FlatButton.icon(
                    color: Colors.yellow[800],
                    onPressed: () {
                      controller.animateToPage(0,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn);
                    },
                    icon: Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      'Chat',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
              FlatButton.icon(
                  color: Colors.yellow[800],
                  onPressed: () {
                    controller.animateToPage(1,
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text('Call',
                      style: TextStyle(color: Colors.white, fontSize: 15))),
              FlatButton.icon(
                  color: Colors.yellow[800],
                  onPressed: () {
                    controller.animateToPage(2,
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  icon: Icon(
                    Icons.group,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text('Conference',
                      style: TextStyle(color: Colors.white, fontSize: 15))),
            ])),
        backgroundColor: Colors.yellow[800],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        leading: FlatButton(
            onPressed: () {
              key.currentState.openDrawer();
            },
            child: Icon(Icons.menu, color: Colors.white)),
        title: Text('Sapphire Meet'),
        centerTitle: true,
      ),
      body: PageView(
        controller: controller,
        children: [
          Chat(),
          Calling(),
          Confrence(),
          Status(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
      
        onPressed: () {
          Navigator.popAndPushNamed(context, '/contacts' );
          print('done');
        },
        child: Icon(Icons.group_add_outlined),
        backgroundColor: Colors.yellow[800],
      ),
    );
  }
}
