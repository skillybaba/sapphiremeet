import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text('About Us'),
          centerTitle: true,
        ),
      body:SingleChildScrollView(child:Center(child:Column(children: [
        SizedBox(height: 60,),
        Image.asset('assests/images/logo.png',width: 170,),

         SizedBox(height: 30,),
         Text("Sapphire Meet",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[800],fontSize: 40)),
         SizedBox(height: 20,),
         Text('''Let's Connect''',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[800],fontSize: 20)),
         SizedBox(height: 160,),
         Row(children: [
           SizedBox(width: 120,),
           Text('MADE',style: TextStyle(color: Colors.orange),),
         SizedBox(width: 10,),
         Text("IN",style: TextStyle(color: Colors.grey[500]),),
         SizedBox(width: 10,),
         Text("INDIA",style: TextStyle(color: Colors.green),)
         ],),
         SizedBox(height: 20,),
         Text('Copyright 2020 ©   Version 2.0.2 '),
         
      ],),
    )));
  }
}