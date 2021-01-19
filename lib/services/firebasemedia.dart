import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "dart:io";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../models/Usermodel.dart";
class FirebaseMedia
{
  File file;
  User user1;
  User user2;
  String text;
  String type;
  FirebaseMedia({this.file,this.user1,this.user2,this.text,this.type});
  
  static void getToken(docid) async
  {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
      var doc = firestore.doc(docid);
      var token = await messaging.getToken();
      SharedPreferences pref = await SharedPreferences.getInstance();
     await pref.setString("tokenValue", token);
      await doc.update({
        "notiToken":token,
      });
    
    

  }
  static Future<String> serverToken(docid) async{
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = firestore.doc(docid);
    var docdata = await doc.get();
    return docdata.data()['notiToken'];
  }
  static void configNoti() async {
    await Firebase.initializeApp();
 FirebaseMessaging messaging = FirebaseMessaging();
 await messaging.configure(onMessage:(map){
   print(map);
 },onLaunch: (map){
   print(map);
 },onBackgroundMessage: (map){
   print(map);
 },onResume: (map){
   print(map);
 });
  }
  static void addUser(docid1,docid2,number1,number2,name1,name2) async{
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc1 = firestore.doc(docid1);
    var doc2 = firestore.doc(docid2);
  
 
      doc1.update({
        number2:{

         'name':name2,
         
          "docid":docid2,
        }
      });
     
        doc2.update({
 number1:{
          'name':name1,
          "docid":docid1,
        }
        });
  
    
  

  }
  sendFile() async{
    await Firebase.initializeApp();
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore firestore=FirebaseFirestore.instance;
    var ref =storage.ref().child('msg images/'+DateTime.now().toString()+user1.phonenumber);
   var upload= ref.putFile(this.file,type=="video"?StorageMetadata(contentType: 'video/mp4'):null);
   var uploadref = await upload.onComplete;

   var link = await uploadref.ref.getDownloadURL();

    var doc1=firestore.doc(user1.docid);
    var doc2 = firestore.doc(user2.docid);
    await doc1.collection(user2.phonenumber).add({
      "user":{
        "name":this.user1.name,
        'docid':this.user1.docid,
        'avatar':null,
      },
      "text":this.text,
      'image':type=="image"?link:null,
      'video':type=="video"?link:null,
      'time':DateTime.now(),
    });
    await doc2.collection(user1.phonenumber).add({
 "user":{
        "name":this.user1.name,
        'docid':this.user1.docid,
        'avatar':null,
      },
      "text":this.text,
      'image':type=="image"?link:null,
      'video':type=="video"?link:null,
      'time':DateTime.now(),
    });
return true;
  }
}