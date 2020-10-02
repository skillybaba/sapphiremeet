import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PaymentService {
  String name;
  String number;
  String api;
  String address;
  String dis;
  int amount;
  String userdocid;
  bool flag = true;
  Razorpay razorpay = Razorpay();
  PaymentService(
      {String name,
      String number,
      String api,
      String address,
      int amount,
      String userdocid,
      String dis}) {
    this.name = name;
    this.number = number;
    this.api = api;
    this.address = address;
    this.amount = amount;
    this.userdocid = userdocid;
    this.dis = dis;
  }
  close() {
    razorpay.clear();
    return true;
  }

  next() {
    razorpay.open({
      'key': this.api,
      'amount': this.amount,
      'name': this.name,
      'description': this.dis,
      'prefill': {'contact': this.number, 'email': 'Enter your Email'}
    });
    print(this.userdocid);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) async {
      await Firebase.initializeApp();
      var ref = FirebaseFirestore.instance;
      print(this.userdocid);
      var doc = ref.doc(this.userdocid);
      doc.update({
        "account":
            this.amount == 39900 ? 'pro' : this.amount == 49900 ? 'bus' : 'N/A',
            'time':DateTime.now().add(Duration(days: 30)),
      });
    });
   
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      this.flag = false;
    });
   
  }
}
