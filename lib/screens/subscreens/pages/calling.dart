import 'package:flutter/material.dart';
import 'package:application/models/callingmodel.dart';

class Calling extends StatefulWidget {
  @override
  _CallingState createState() => _CallingState();
}

class _CallingState extends State<Calling> {
  List<CallingModel> callinglist = <CallingModel>[
    CallingModel(number: '+91192312231', name: 'someone'),
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index < callinglist.length) {
            return FlatButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(40),
                      color: Colors.yellow[800]),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "${callinglist[index].name}",
                        style: TextStyle(fontSize: 21,color: Colors.white),
                        
                      ),
                      SizedBox(width: 70,),
                      Icon(Icons.call,color: Colors.white,)
                    ],
                  ),
                ));
          }
        }))
      ],
    );
  }
}
