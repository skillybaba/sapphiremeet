import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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
  static Future<void> storeMedia(File file,type) async {
    try {
      await Firebase.initializeApp();
      StorageReference firebasestorage = FirebaseStorage()
          .ref()
          .child("gs://sapphire-meet.appspot.com/msg images/"+type);
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
      await user.get().then((value) {
        value.docs.forEach((element) {
          finallist.add(element.data()['number']);
          map[element.data()['number']] = element.data()['Doc Id'];

          name[element.data()['number']] = element.data()['username'];
          print(element.data()['number']);
        });
      });
      List<String> list = [];
      for (var i in contact) {
        for (var j in finallist) {
          i.phones.any((element) {
            if (element.value.replaceAll(' ', '') == j) {
              list.add(j);
              docid.add(map[element.value]);
              name1.add(name[element.value]);
            }

            return true;
          });
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('contact list', list);
      await prefs.setStringList('contact docid', docid);
      await prefs.setStringList('contact name', name1);
      await prefs.setBool('contact fetched', true);
      return [list, docid, name1];
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

  Future<void> addDP(File file, metadata) async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StorageReference storageReference = FirebaseStorage().ref().child(
        'gs://sapphire-meet.appspot.com/profile images/' +
            prefs.getStringList('your info')[0]);
    var upload = storageReference.putFile(file);
    var ref = await upload.onComplete;

    var val = prefs.getStringList('your info');
    var firebase = FirebaseFirestore.instance;
    var firestore = firebase.doc(val[2]);
    await firestore.update({'DP': await ref.ref.getPath()});
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path + '/Display';
    File dp = File(path);
    dp.deleteSync();
    dp.writeAsBytesSync(file.readAsBytesSync());
    await prefs.setString('DP', path);
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
