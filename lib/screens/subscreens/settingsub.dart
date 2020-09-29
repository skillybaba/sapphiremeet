import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        
        children: [
          Positioned(
            left:120,
            top:30,
              child: CircularProfileAvatar(
            this.imageurl,
            radius: 40,
          )),
           Positioned(
           
           
             child:Container(
            child: Column(
              children: [
                Text('Your Number:  ${info[0]}'),
                Text('Your Name:  ${info[1]}'),

              ],
            ),
          ))
        ],
      ),
    );
  }
}
