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
        await user.add({
          'number': this.number,
          'username': this.username,
        }).then((value) async {
          print('done');
          await Firebase.initializeApp();
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          CollectionReference usermsg = firestore.collection('msg');

          await usermsg
              .add({'name': this.username, 'number': this.number}).then(
                  (value) async {
            docid = value;
          }).catchError((error) {});
          await user.doc(value.id).update({'Doc Id': docid.path});
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setStringList(
              'your info', [this.number, this.username, docid.path]);
          print('done121');
        }).catchError((onError) {
          print('something went wrong,$onError');
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
