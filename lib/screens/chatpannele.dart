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
import "dart:convert";
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:http/http.dart';
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
  AdaptiveThemeMode thememode;
  List<ChatMessage> message = [];
 
  bool firsttime=false;
  bool retrive=true;
  bool retrivedp = false;
  Map chats={};
  Map useravatar = {};
  String serverToken;
  
  var snap;
  void initState()
  {

    super.initState();
    
      (()async{
      this.thememode = await AdaptiveTheme.getThemeMode();

    })();
  }
  getAvatar() async{
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
        SharedPreferences pref = await SharedPreferences.getInstance();
        info = pref.getStringList('your info');
        
    var doc1 = firestore.doc(info[2]);
    var doc2 = firestore.doc(data['docid']);
    var dataref = await doc2.get();
    var data2=dataref.data();
    if(pref.containsKey('dp'))
    {
      var datanumber=data2[info[0]];
      datanumber["avatar"]=pref.getString('dp');
      useravatar['user1']=pref.getString('dp');
     doc2.update({info[0]:datanumber});

    }
    if(data2.containsKey("DP"))
    {
      var doc1data = await doc1.get();
      var datanumber=doc1data.data();
      var update = datanumber[data['number']];
      update["avatar"]=data2['DP'];
      useravatar['user2']=data2['DP'];
     doc1.update({
        data['number']:update
      });

    }
    this.retrivedp=true;

    // pref.setString(data['number'],);
  }
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
    "name":data['user']['name'],
    'docid':data['user']['docid'],
    'avatar':data['user']['avatar'],

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
     this.message.add(ChatMessage(video: chats[element]['video']??null,image: chats[element]['image']??null,createdAt: chats[element]['time'].toDate(),text: chats[element]['text'],user:ChatUser(name:chats[element]['user']['name'],avatar: chats[element]['user']['avatar'])));
   });

}
else{
  var data = event.docChanges.first.doc.data();
  
  this.message.add(ChatMessage(video: data['video']??null,image: data['image']??null,createdAt: data['time'].toDate(),text:data['text'],user:ChatUser(name:data['user']['name'],avatar: data['user']['avatar'])));

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
    if(this.serverToken==null)(()async{
     this.serverToken= await FirebaseMedia.serverToken(data['docid']);
     setState((){});

    })();
  if(!this.retrivedp) getAvatar();
    if(this.retrive) messageRetrive();
    if((!this.retrive)||(this.retrivedp)||(this.serverToken!=null))
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
    },)),body:LoadingOverlay(isLoading:this.loading ,child:DashChat(
      key:key,
        alwaysShowSend: true,
           messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                  return BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color:msg.user.name==info[1]
                        ? Colors.yellow[800]
                        : Colors.white, // example
                  );
                },
                messageImageBuilder: (url, [chat]) {
                  return Image.network(
                    url,
                    height: 250,
                  );
                },
      inputTextStyle: TextStyle(color: Colors.black),
      inputContainerStyle: BoxDecoration(color: this.thememode.isDark?Colors.grey:Colors.white),
         
                messageTextBuilder: (message, [chat]) {
                  return Text(
                    message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: chat.user.name == info[1]
                            ? Colors.white
                            : Colors.yellow[800]),
                  );
                },
                dateBuilder: (date) {
                  return Text(date, style: TextStyle(color: Colors.grey[400]));
                },
                onLongPressMessage: (ChatMessage message) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Image.network(message.image,height: 100,);
                    },
                  );
                },
                onPressAvatar: (ChatUser user) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Image.network(user.avatar,height: 100,);
                      });
                },
      trailing: [
      IconButton(icon: Icon(Icons.attach_file,color:Colors.yellow[800]),onPressed: (){
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
    'avatar':useravatar.containsKey("user1")?useravatar['user1']:null,

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
    'avatar':useravatar.containsKey("user1")?useravatar['user1']:null,
    

  },
  'text':message.text,
  'time':DateTime.now(),
  'image':message.image,
  'video':message.video,
 });

post("'https://fcm.googleapis.com/fcm/send',",headers: <String,String>{
'Content-Type': 'application/json',
       'Authorization': 'key=${pref.getString('tokenValue')}',
      
},body:  jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': {"name":"${data['name']}","message":message.text},
         'title': 'message'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': this.serverToken
     },
    ),);
     
    },user: ChatUser(firstName:info[1]),)));
    
    else
    return SpinKitRing(
                color: Colors.yellow[800],
              );
  }
}