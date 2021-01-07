import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "dart:io";
import 'package:firebase_core/firebase_core.dart';
import "../models/Usermodel.dart";
class FirebaseMedia
{
  File file;
  User user1;
  User user2;
  String text;
  String type;
  FirebaseMedia({this.file,this.user1,this.user2,this.text,this.type});
  static void addUser(docid1,docid2,number1,number2) async{
    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc1 = firestore.doc(docid1);
    var doc2 = firestore.doc(docid2);
  
 
      doc1.update({
        number2:{
         
          "docid":docid2,
        }
      });
     
        doc2.update({
 number1:{
          
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