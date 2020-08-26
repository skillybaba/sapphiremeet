import 'package:application/models/statusmodel.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<StatusModel> statuslist = <StatusModel>[
    StatusModel(name: 'someone', number: '+184928323249')
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index == 0) return FlatButton(onPressed: (){},child:Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(5),
            child: Row(children: [
              SizedBox(width: 50,),
            Icon(Icons.data_usage_rounded,color:Colors.yellow[800],size:60),
              SizedBox(width: 10,),
              Text('My Status',style: TextStyle(color: Colors.yellow[800],fontSize: 20),),
             

            ],),
          ));
          else if (index-1 < statuslist.length)
            return FlatButton(onPressed: (){},child:Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    SizedBox(width: 60,),
                    Icon(Icons.data_usage,size:40,color: Colors.yellow[800]),
                    SizedBox(width: 30,),
                    Text('${statuslist[index-1].name}',style: TextStyle(fontSize: 16,color: Colors.yellow[800]),),
                  ],
                )));
        })),
      ],
    );
  }
}
