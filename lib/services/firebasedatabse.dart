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
  FireBaseDataBase({String username, String number, data}) {
    this.username = username;
    this.number = number;
    this.data = data;
  }
  static Future<void> storeMedia(File file) async {
    try {
      await Firebase.initializeApp();
      StorageReference firebasestorage = FirebaseStorage()
          .ref()
          .child("gs://sapphire-meet.appspot.com/msg images");
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
      List docid = [];
      var map = {};
      await user.get().then((value) {
        value.docs.forEach((element) {
          finallist.add(element.data()['number']);
          map[element.data()['number']] = element.data()['Doc Id'];
          print(element.data()['number']);
        });
      });
      var list = [];
      for (var i in contact) {
        for (var j in finallist) {
          i.phones.any((element) {
            if (element.value.replaceAll(' ', '') == j) {
              list.add(j);
              docid.add(map[element.value]);
            }

            return true;
          });
        }
      }

      return [list, docid];
    } catch (e) {
      print(e);
    }
  }

  Future<void> setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs
        .setStringList('your info', [this.number, this.username, docid.path]);
    print('done121');
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
        });
        print('done');

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usermsg = firestore.collection('msg');

        docid =
            await usermsg.add({'name': this.username, 'number': this.number});
        print(docid.path);
        await user.doc(user1.id).update({'Doc Id': docid.path});
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(this.number, docid.path);
        print('done121');
      } else {
        var user1 = await user.get();
        var docidpath;
        user1.docs.forEach((element) {
          if (element.data()['number'] == this.number)
             docidpath = element.data()['Doc Id'];
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(this.number, docidpath);
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
