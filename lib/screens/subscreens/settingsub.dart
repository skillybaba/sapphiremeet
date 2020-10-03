import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingSub extends StatefulWidget {
  var info, imageurl;
  SettingSub({info, imageurl}) {
    this.info = info;
    this.imageurl = imageurl;
  }
  @override
  _SettingSubState createState() =>
      _SettingSubState(info: info, imageurl: imageurl);
}

class _SettingSubState extends State<SettingSub> {
  var info, imageurl;
  _SettingSubState({info, imageurl}) {
    this.info = info;
    this.imageurl = imageurl;
  }
  SharedPreferences pref;
  var flag = false;
  void th() async {
    pref = await SharedPreferences.getInstance();
    setState(() {});
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    th();
    if (flag)
      return Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(top: 80, bottom: 120, left: 30, right: 30),
            margin: EdgeInsets.only(
              top: 110,
              left: 30,
            ),
            child: Column(
              children: [
                Text(
                  'Your Number:  ${info[0]}',
                  style: TextStyle(
                      color: Colors.yellow[800],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Your Name:  ${info[1]}',
                  style: TextStyle(
                      color: Colors.yellow[800],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                // Switch(
                //     activeColor: Colors.yellow[800],
                //     value: pref.getInt('theme') == 1 ? false : true,
                //     onChanged: (val) async {
                //       if (pref.getInt('theme') == 1)
                //         await pref.setInt('theme', 0);
                //       else
                //         await pref.setInt('theme', 1);

                //       print(pref.getInt('theme'));
                //       setState(() {});
                //       print('done');
                //     }),
                RaisedButton.icon(
                    color: Colors.yellow[800],
                    onPressed: () {
                      Navigator.pushNamed(context, '/History');
                    },
                    icon: Icon(Icons.history, color: Colors.white),
                    label: Text(
                      "View Meeting History",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  height: 50,
                ),
                IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.yellow[800]),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10, left: 70, right: 30),
              margin: EdgeInsets.only(
                top: 20,
                left: 40,
              ),
              child: this.imageurl!=null? CircularProfileAvatar(
                this.imageurl,
                borderWidth: 10,
                borderColor: Colors.black,
                radius: 70,
              ):Icon(Icons.supervised_user_circle_rounded,color:Colors.white,size: 120,)),
        ],
      );
    else
      return SpinKitCubeGrid(color: Colors.yellow[800]);
  }
}
