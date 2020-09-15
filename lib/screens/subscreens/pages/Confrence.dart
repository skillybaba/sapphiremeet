import 'package:flutter/material.dart';
import 'package:application/services/conferenceservice.dart';

class Confrence extends StatefulWidget {
  @override
  _ConfrenceState createState() => _ConfrenceState();
}

class _ConfrenceState extends State<Confrence> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 90,
          ),
          FlatButton.icon(
            onPressed: () async {
              await Conf_Service(
                      'kanishk', 'meeting', 'kaniskh', 'kanu0704@gmail.com')
                  .hostMeet();
            },
            icon: Icon(Icons.meeting_room, color: Colors.yellow[800], size: 40),
            label: Text(
              'Host A Meeting',
              style: TextStyle(
                  color: Colors.yellow[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'OR',
            style: TextStyle(
                color: Colors.yellow[800],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    hintText: 'Enter the Meeting Code here to Join'),
              )),
          SizedBox(
            height: 10,
          ),
          FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.merge_type, color: Colors.yellow[800], size: 40),
              label: Text('Join',
                  style: TextStyle(
                      color: Colors.yellow[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
