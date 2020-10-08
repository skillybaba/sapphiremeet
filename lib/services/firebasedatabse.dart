import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseDataBase {
  String username;
  String number;
  var data;
  var docid;
  String dp;
  FireBaseDataBase({String username, String number, data}) {
    this.username = username;
    this.number = number;
    this.data = data;
  }
  static Future<void> storeMedia(File file, type) async {
    try {
      await Firebase.initializeApp();
      StorageReference firebasestorage = FirebaseStorage()
          .ref()
          .child("gs://sapphire-meet.appspot.com/msg images/" + type);
      firebasestorage.putFile(file);
    } catch (e) {
      print(e);
    }
  }

  Future<List> fetchContact() async {
    try {
      List<Contact> contact;
      if (await Permission.contacts.request().isGranted)
        contact =
            (await ContactsService.getContacts(withThumbnails: false)).toList();
      await Firebase.initializeApp();
      FirebaseFirestore users = FirebaseFirestore.instance;
      CollectionReference user = users.collection('users');
      List finallist = [];
      List<String> docid = [];
      var map = {};
      var name = {};
      List<String> name1 = [];
      List<String> list = [];
      var ref = await user.get();
      var datacon = ref.docs.forEach((element) {
        for (var i in contact) {
          i.phones.any((element1) {
            if (element.data()['number'] != null) {
              if (element
                      .data()['number']
                      .contains(element1.value.replaceAll(' ', '')) ||
                  (name[element1.value] != null)) {
                docid.add(element.data()['Doc Id']);
                name1.add(element.data()['username']);
                list.add(element.data()['number']);
              }
            }
            return true;
          });
        }
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('contact list', list);
      await prefs.setStringList('contact docid', docid);
      await prefs.setStringList('contact name', name1);
      await prefs.setBool('contact fetched', true);
      return [
        list.toSet().toList(),
        docid.toSet().toList(),
        name1.toSet().toList()
      ];
    } catch (e) {
      print(e);
    }
  }

  msgImg(file) async {
    await Firebase.initializeApp();
    var st = FirebaseStorage()
        .ref()
        .child('msg images/' + DateTime.now().toString() + this.number);
    var upload = st.putFile(file);
    var uploadref = await upload.onComplete;
    return uploadref.ref.getDownloadURL();
  }

  Future<void> setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs
        .setStringList('your info', [this.number, this.username, docid.path]);
    print('done121');
  }

  Future<void> fetchDP() async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var val = prefs.getStringList('your info');

    var firebase = FirebaseFirestore.instance;
    var firestore = firebase.doc(val[2]);
    var dataref = await firestore.get();
    var data = dataref.data()['DP'];

    this.dp = data;
  }

  Future<void> addDP(File file, [metadata]) async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StorageReference storageReference = FirebaseStorage()
        .ref()
        .child('gs://sapphire-meet.appspot.com/profile images/' + this.number);
    var upload = storageReference.putFile(file);
    var ref = await upload.onComplete;

    var val = prefs.getStringList('your info');
    var firebase = FirebaseFirestore.instance;
    var firestore = firebase.doc(val[2]);
    await firestore.update({'DP': await ref.ref.getDownloadURL()});
  }

  Future<void> addUser() async {
    try {
      bool val = true;
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('$number,$username');
      CollectionReference user = firestore.collection('users');

      await user.get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['number'] == number) {
            if (val) val = false;
          }
        });
      }).catchError((onerror) {
        print(
          'somethign went wrong,$onerror',
        );
      });

      if (val) {
        var user1 = await user.add({
          'number': this.number,
          'username': this.username,
          'account': 'free',
        });

        print('done');

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usermsg = firestore.collection('msg');

        docid =
            await usermsg.add({'name': this.username, 'number': this.number});
        print(docid.path);
        await user.doc(user1.id).update({'Doc Id': docid.path});
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userdocid', user1.path);
        await prefs.setString(this.number, docid.path);
        print('done121');
      } else {
        var user1 = await user.get();
        var docidpath;
        var userdoc;
        user1.docs.forEach((element) {
          if (element.data()['number'] == this.number) {
            docidpath = element.data()['Doc Id'];
            userdoc = element.reference.path;
          }
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(this.number, docidpath);
        await prefs.setString('userdocid', userdoc);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setStringList('your info',
          [this.number, this.username, prefs.getString(this.number)]);
      print('done121');
    } catch (e) {
      print(e);
    }
  }
}
