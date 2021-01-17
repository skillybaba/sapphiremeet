import 'package:application/services/firebasedatabse.dart';
import 'package:application/services/imageselectservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './subscreens/pages/chatPannel.dart';
import './subscreens/pages/Confrence.dart';
import './subscreens/pages/calling.dart';
import './subscreens/pages/status.dart';
import 'package:application/services/authvals.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List check = [0];
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  PageController controller = PageController(initialPage: 2);
  logout() async {
    await AuthVals().deleteVals('userinfo', 'auth');
    Navigator.pushReplacementNamed(context, '/');
  }

  String dp;
  SharedPreferences pref;
  void prefs() async {
    pref = await SharedPreferences.getInstance();
    setState(() {});
  }

  void initState() {
    super.initState();
    prefs();
  }

  void dispose() {
    super.dispose();
  }

  var info;
  var flag = false;
  getDp() async {
    if (pref != null) {
      var ref = FireBaseDataBase(number: pref.getStringList('your info')[0]);
      await ref.fetchDP();
      dp = ref.dp;
      if (dp != null)
        setState(() {
          flag = true;
        });
    }
  }

  bool dpcheck = false;
  bool ff = true;
  int i = 0;
  @override
  Widget build(BuildContext context) {
    if (!flag) getDp();
    return Scaffold(
      key: key,
      drawer: Drawer(
          child: SingleChildScrollView(
              child: Column(children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.yellow[800],
          ),
          accountName: Text(
            pref.getStringList('your info')[1],
            style: TextStyle(fontSize: 16),
          ),
          accountEmail: Text(pref.getStringList('your info')[0],
              style: TextStyle(fontSize: 14)),
          currentAccountPicture: dp != null
              ? Container(
                  child: FlatButton(
                      onPressed: () async {
                        await showCupertinoDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                content: Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        FlatButton(onPressed: ()async{
                                          showDialog(context: context,builder: (context)=>AlertDialog(content: Image.network(dp),));
                                        },child:Text("View Image",style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              var crop = await ImageSelect(
                                                      context: context)
                                                  .image();
                                              setState(() {
                                                dpcheck = true;
                                              });
                                              await FireBaseDataBase(
                                                      number:
                                                          pref.getStringList(
                                                              'your info')[0])
                                                  .addDP(
                                                crop,
                                              );
                                              setState(() {
                                                ff = false;
                                                flag = false;
                                                dpcheck = false;
                                              });
                                            },
                                            child: Text("From Gallery",
                                                style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              var crop = await ImageSelect(
                                                      context: context,
                                                      selecttype: 'camera')
                                                  .image();
                                              setState(() {
                                                dpcheck = true;
                                              });
                                              var link = await FireBaseDataBase(
                                                      number:
                                                          pref.getStringList(
                                                              'your info')[0])
                                                  .addDP(
                                                crop,
                                              );
                                             SharedPreferences pref2 = await SharedPreferences.getInstance();
                                             await pref2.setString('dp', link);
                                              setState(() {
                                                ff = false;
                                                flag = false;
                                                this.i++;
                                              });
                                            },
                                            child: Text(
                                              "From Camera",
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ))));
                      },
                      child: dpcheck == false
                          ? CircularProfileAvatar(dp,
                             )
                          : SpinKitPulse(color: Colors.white)))
              : IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await showCupertinoDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                content: Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                ),
                                FlatButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      var crop =
                                          await ImageSelect(context: context)
                                              .image();
                                      setState(() {
                                        dpcheck = true;
                                      });
                                     var link= await FireBaseDataBase(
                                              number: pref.getStringList(
                                                  'your info')[0])
                                          .addDP(
                                        crop,
                                      );
                                       SharedPreferences pref2 = await SharedPreferences.getInstance();
                                             await pref2.setString('dp', link);
                                      setState(() {
                                        ff = false;
                                        dpcheck = false;
                                        flag = false;
                                      });
                                    },
                                    child: Text("From Gallery",
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold))),
                                FlatButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      var crop = await ImageSelect(
                                              context: context,
                                              selecttype: 'camera')
                                          .image();
                                      setState(() {
                                        dpcheck = true;
                                      });
                                      await FireBaseDataBase(
                                              number: pref.getStringList(
                                                  'your info')[0])
                                          .addDP(
                                        crop,
                                      );

                                      setState(() {
                                        ff = false;
                                        flag = false;
                                        dpcheck = false;
                                      });
                                    },
                                    child: Text("From Camera",
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold))),
                              ],
                            )));
                  },
                  icon: dpcheck == false
                      ? Icon(Icons.account_circle)
                      : SpinKitPulse(color: Colors.white),
                  iconSize: 80,
                  color: Colors.white,
                ),
        ),
        ListTile(
            subtitle: Text('click to see about us'),
            onTap: () {
              Navigator.pushNamed(context, '/aboutus');
            },
            leading: Icon(
              Icons.info_outline,
            ),
            title: Text(
              'ABOUT US',
            )),
        ListTile(
            subtitle: Text('click here'),
            onTap: () {
              Navigator.pushNamed(context, '/contactus');
            },
            leading: Icon(
              Icons.contact_support_sharp,
            ),
            title: Text(
              'CONTACT US',
            )),
        ListTile(
            subtitle: Text('click here to use calculator'),
            onTap: () {
              Navigator.pushNamed(context, '/Calculator');
            },
            leading: Icon(
              Icons.calculate,
            ),
            title: Text(
              'CALCULATOR',
            )),
        ListTile(
            subtitle: Text('click here to inspect settings'),
            onTap: () {
              Navigator.pushNamed(context, '/setting', arguments: {
                'data': pref.getStringList('your info'),
                'url': this.dp,
              });
            },
            leading: Icon(
              Icons.settings,
            ),
            title: Text(
              'SETTINGS',
            )),
        ListTile(
          title: Text('SAPPHIRE-WEB'),
          subtitle: Text('get code to login to the sapphire-web'),
          leading: Icon(Icons.network_wifi),
          onTap: () {
            Navigator.pushNamed(context, '/web');
          },
        ),
        ListTile(
            subtitle: Text('click here to upgrade'),
            onTap: () {
              Navigator.pushNamed(context, '/payments', arguments: {
                'info': pref.getStringList('your info'),
                'userdocid': pref.getString('userdocid'),
              });
            },
            leading: Icon(
              Icons.upgrade_outlined,
            ),
            title: Text(
              'UPGRADE',
            )),
        ListTile(
          subtitle: Text('click here to logout'),
          onTap: logout,
          leading: Icon(Icons.logout),
          title: Text(
            "LOGOUT",
          ),
        ),
      ]))),
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                controller.animateToPage(3,
                    duration: Duration(seconds: 1), curve: Curves.easeOutCirc);
                check[0] = 3232;
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
                          curve: Curves.easeOutCirc);
                      check[0] = 0;
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
                        curve: Curves.easeOutCirc);
                    check[0] = 3232;
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
                        curve: Curves.easeOutCirc);
                    check[0] = 3232;
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
          Chat(check: check),
          Calling(check: check),
          Confrence(
            check: check,
          ),
          Status(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/contacts');
          print('done');
          check[0] = 343;
        },
        child: Icon(Icons.group_add_outlined),
        backgroundColor: Colors.yellow[800],
      ),
    );
  }
}
