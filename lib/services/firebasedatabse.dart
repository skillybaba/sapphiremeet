import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseDataBase {
  String username;
  String number;
  var data;

  FireBaseDataBase({String username, String number, data}) {
    this.username = username;
    this.number = number;
    this.data = data;
  }
  Future<void> addUser() async {
    try {
      bool val = false;
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('$number,$username');
      CollectionReference user = firestore.collection('users');
      await user.get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['number'] != number) {
            val = true;
          }
        });
      }).catchError((onerror) {
        print('somethign went wrong,$onerror',);
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
