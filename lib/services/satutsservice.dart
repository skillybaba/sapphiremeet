import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StatusService {
  File status;
  String statusURL;
  String number;
  String docid;
  StatusService({File status, String statusURL, String number, String docid}) {
    this.status = status;
    this.statusURL = statusURL;
    this.number = number;
    this.docid = docid;
  }
  setStatus() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    var ref = storage.ref().child('status/' + this.number);
    var upload = ref.putFile(status);
    var uploadref = await upload.onComplete;
    var dbref = db.doc(docid);
    var docref = await dbref.get();
    var data = docref.data();
    dbref.update({'status': await uploadref.ref.getDownloadURL()});
    return true;
  }

  getStatus() async {
    FirebaseFirestore ref = FirebaseFirestore.instance;
    var dbref = ref.doc(docid);
    var docref = await dbref.get();
    var data = docref.data()['status'];
    return data;
  }
}
