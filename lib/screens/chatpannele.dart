import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toast/toast.dart';
import '../services/imageselectservice.dart';
import '../services/firebasedatabse.dart';
import '../models/Usermodel.dart';
import "../services/firebasemedia.dart";

class ChatPannel extends StatefulWidget {
  @override
  _ChatPannelState createState() => _ChatPannelState();
}

class _ChatPannelState extends State<ChatPannel> {
  Map data;
  var info;
  bool isloading = false;
  bool flag = false;
  GlobalKey<DashChatState> key = GlobalKey<DashChatState>();
  List<ChatMessage> message = [];
 
  bool firsttime=false;
  bool retrive=true;
  Map chats={};
  var snap;
  messageRetrive() async{
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
        info = pref.getStringList('your info');
    var doc = firestore.doc(info[2]);
   this.snap= doc.collection(data['number']).snapshots().listen((event) {
     int testlength=chats.length;
     event.docChanges.forEach((element) { 
       var data= element.doc.data();
    
       chats[data['time']]={
          "user":{
    "name":info[1],
    'docid':data['docid'],
    'avatar':null,

  },
  'text':data['text'],
  'image':data['image'],
  'video':data['video'],
  'time':data['time'],
       };
      
     
     });
if(testlength==0){
   var list =   chats.keys.toList();
   list.sort();
   list.forEach((element) { 
     this.message.add(ChatMessage(video: chats[element]['video']??null,image: chats[element]['image']??null,createdAt: chats[element]['time'].toDate(),text: chats[element]['text'],user:ChatUser(name:chats[element]['user']['name'])));
   });

}
else{
  var data = event.docChanges.first.doc.data();
  
  this.message.add(ChatMessage(video: data['video']??null,image: data['image']??null,createdAt: data['time'].toDate(),text:data['text'],user:ChatUser(name:data['user']['name'])));

}
setState(() {
  
});
    });
    this.retrive=false;
  }
void dispose()
{
  super.dispose();
  snap.cancel();
}
bool loading=false;

  @override
  Widget build(BuildContext context) {
    this.data = ModalRoute.of(context).settings.arguments;
   
    if(this.retrive) messageRetrive();
    if(!this.retrive)
    return Scaffold(appBar: AppBar(actions: [IconButton(icon: Icon(Icons.call),onPressed: ()async {

                  setState(() {
                    isloading = true;
                  });
                  Toast.show("Connecting Call Plz Wait", context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.BOTTOM,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white);

                  await Firebase.initializeApp();
                  var firestore = FirebaseFirestore.instance;
                  var doc = firestore.doc(data['docid']);
                  var doc2 = firestore.doc(info[2]);
                  
                  var ref2 = await doc.get();
                  var data2 = ref2.data();
                  var ref = await doc2.get();
                  print(data['docid']);
                  var data1 = ref.data();
                  if (((data1['receving'] == null) || (!data1['receving'])) &&
                      ((data1['connected'] == null) || (!data1['connected']))) {
                    print((data['number'].substring(1) + info[0].substring(1)));
                    await doc.update({
                      'receving': true,
                      'caller': info,
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1)),
                    });
                    await doc2.update({
                      'calling': true,
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1))
                    });
                  
                    setState(() {
                      isloading = false;
                    });
                    Navigator.pushNamed(context, '/caller', arguments: {
                      
                      'number': data['number'],
                      'type': 'calling',
                      'recever': data['docid'],
                      'caller': info[2],
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1)),
                      'check': [2],
                    });
                    doc.collection("calling").add({
 'type': 'receving',
                      'number': info[0],
                      'name': info[1],
                      'docid': info[2],
                    });
                    doc2.collection('calling').add({
                       'type': 'calling',
                      'number': data['number'],
                      'name': data['name'],
                      'docid': data['docid'],
                      
                    });
                   
                  } else {
                    Navigator.pushNamed(context, '/caller', arguments: {
                      'number': data['number'],
                      
                      'type': 'buzy',
                      'recever': data['docid'],
                      'caller': info[2],
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1)),
                      'check': [2]
                    });
                    doc2.update({
                      'calling': true,
                      'channelid':
                          (data['number'].substring(1) + info[0].substring(1))
                    });
                    setState(() {
                      isloading = false;
                    });
                  }
               
    },)],
      title:Text(data['name']),backgroundColor: Colors.yellow[800],leading: IconButton(icon:Icon(Icons.arrow_left),onPressed: (){
      Navigator.popAndPushNamed(context, '/home');
    },)),body:LoadingOverlay(isLoading:this.loading ,child:DashChat(trailing: [
      IconButton(icon: Icon(Icons.attach_file),onPressed: (){
        showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Select"),
              content: Container(
                height: 320,
                child:ListView(children: [
                ListTile(leading: Icon(Icons.image),title: Text('Image'),subtitle: Text('Gallery'), onTap:()async {
                  var instance = ImageSelect(context: context);
                  
                  setState(() {
                    this.loading=true;
                  });
                  Navigator.pop(context);
                  

                  var file = await instance.image();
                  var mediaUpload = await FirebaseMedia(file: file,user1:User(name: info[1],docid:info[2],phonenumber: info[0]),user2:User(name: data['name'],docid:data['docid'],phonenumber: data['number']),type: 'image',text: 'media').sendFile();
                this.loading=false;
                setState(() {
                  
                });
                }),
                 ListTile(leading: Icon(Icons.image),title: Text('Image'),subtitle: Text('Camera'), onTap:() async {
                   var instance = ImageSelect(context: context,selecttype: "camera");
                  
                  setState(() {
                    this.loading=true;
                  });
                  Navigator.pop(context);
                  

                  var file = await instance.image();
                  var mediaUpload = await FirebaseMedia(file: file,user1:User(name: info[1],docid:info[2],phonenumber: info[0]),user2:User(name: data['name'],docid:data['docid'],phonenumber: data['number']),type: 'image',text: 'media').sendFile();
                this.loading=false;
                setState(() {
                  
                });
                }),
                ListTile(leading: Icon(Icons.video_collection),title: Text('Video'),subtitle: Text('Gallery'),onTap: ()async{
                   var instance = ImageSelect(context: context,selecttype: "video");
                  
                  setState(() {
                    this.loading=true;
                  });
                  Navigator.pop(context);
                  

                  var file = await instance.image();
                  var mediaUpload = await FirebaseMedia(file: file,user1:User(name: info[1],docid:info[2],phonenumber: info[0]),user2:User(name: data['name'],docid:data['docid'],phonenumber: data['number']),type: 'video',text: 'media').sendFile();
                this.loading=false;
                setState(() {
                  
                });
                },),
                 ListTile(leading: Icon(Icons.video_collection),title: Text('Video'),subtitle: Text('Camera'),onTap: ()async{
                    var instance = ImageSelect(context: context,selecttype: "video_camera");
                  
                  setState(() {
                    this.loading=true;
                  });
                  Navigator.pop(context);
                  

                  var file = await instance.image();
                  var mediaUpload = await FirebaseMedia(file: file,user1:User(name: info[1],docid:info[2],phonenumber: info[0]),user2:User(name: data['name'],docid:data['docid'],phonenumber: data['number']),type: 'video',text: 'media').sendFile();
                this.loading=false;
                setState(() {
                  
                });
                 },),
         
         
              ],),
              
              
            ));
          }
        );
      },)
    ],messages: this.message,onSend: (message) async{
      print(3);
        await Firebase.initializeApp();
        print(31);
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        SharedPreferences pref = await SharedPreferences.getInstance();
        info = pref.getStringList('your info');
        var doc1 = firestore.doc(info[2]);
        var doc2 = firestore.doc(data['docid']);
  doc1.collection(data['number']).add({
  "user":{
    "name":info[1],
    'docid':data['docid'],
    'avatar':null,

  },
  'text':message.text,
  'image':message.image,
  'video':message.video,
  'time':DateTime.now(),
 });
 doc2.collection(info[0]).add({
 "user":{
    "name":info[1],
    'docid':data['docid'],
    'avatar':null,
    

  },
  'text':message.text,
  'time':DateTime.now(),
  'image':message.image,
  'video':message.video,
 });


     
    },user: ChatUser(firstName:info[1]),)));
    
    else
    return SpinKitRing(
                color: Colors.yellow[800],
              );
  }
}