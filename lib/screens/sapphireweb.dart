import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';

class Sapphireweb extends StatefulWidget {
  @override
  _SapphirewebState createState() => _SapphirewebState();
}

class _SapphirewebState extends State<Sapphireweb> {
  GlobalKey qrKey = GlobalKey();
  void func(BuildContext context,codedata) async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    var doc = firestore.doc('web/0ysJuZ64RshAHyBnbMqc');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var code = pref.getStringList('your info');
    
   
    doc.update({
      codedata: pref.getString('userdocid'),
      
    });
    sub.cancel();
    Toast.show('Logged_in', context);
    
    
  
    
  }
  QRViewController controller;
  StreamSubscription<Barcode> sub;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text('Sapphire-Web'),
          centerTitle: true,
        ),
        body: Stack(children:[
         
          QRView(key:qrKey,onQRViewCreated: (controller){
          this.controller=controller;
          this.sub=this.controller.scannedDataStream.listen((event) { 
            
          this.func(context, event.code);
          
            });
          
        },), Container(margin: EdgeInsets.all(30),child: Text("Scan your QR code",style: TextStyle(color: Colors.yellow[800],fontSize: 30),),),]));
  }
}
