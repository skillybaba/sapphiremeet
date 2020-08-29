import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class FireBaseDataBase {
  String username;
  String number;
  var data;

  FireBaseDataBase({String username, String number, data}) {
    this.username = username;
    this.number = number;
    this.data = data;
  }
  Future<void> storeMedia(File file) async {
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
      await user.get().then((value) {
        value.docs.forEach((element) {
          finallist.add(element.data()['number']);
          print(element.data()['number']);
        });
      });
      var list = [];
      for (var i in contact) {
        for (var j in finallist) {
          i.phones.any((element) {
           
            if (element.value.replaceAll(' ', '') == j) list.add(j);

            return true;
          });
        }
      }
      return list;
    } catch (e) {
      print(e);
    }
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
            if(val)
            val = false;
          }
        });
      }).catchError((onerror) {
        print(
          'somethign went wrong,$onerror',
        );
      });

      if (val) {
        await user
            .add({
              'number': this.number,
              'username': this.username,
            })
            .then((value) => print(value))
            .catchError((onError) {
              print('something went wrong,$onError');
            });
      }
    } catch (e) {
      print(e);
    }
  }
}
