import 'package:application/services/paymentservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map data;
  bool flag = false;
  var docdata;
  check() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    var ref = FirebaseFirestore.instance;
    var doc = ref.doc(pref.getString('userdocid'));
    var docdata = await doc.get();
    this.docdata = docdata;
    setState(() {
      this.flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    check();
    data = ModalRoute.of(context).settings.arguments;
    PaymentService service = PaymentService(
        address: '',
        api: "rzp_live_OJXiAs7A475Myu",
        number: data['info'][0],
        userdocid: data['userdocid'],
        amount: 0);
    if (flag)
      return Scaffold(
          appBar: AppBar(
            title: Text('Upgrade'),
            centerTitle: true,
            backgroundColor: Colors.yellow[800],
          ),
          body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(left: 40, top: 20),
                  child: Column(
                    children: [
                      Text(
                        "✬✬ FREE GIFT ON  ✬✬",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[300],
                            fontSize: 20),
                      ),
                      Text(
                        "✬✬ EVERY UPGRADATION ✬✬ ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[300],
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      docdata.data()['account'] == "free"
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.yellow[800],
                              elevation: 20,
                              child: Column(children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text('BASIC',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Personal Meeting',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Host up to 100 participants',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('1 hour group meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Unlimited 1:1 meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free 1:1 chatting and group chatting',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Voice and Video Call',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Video Conferencing Features',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 20,
                                ),
                                FlatButton(
                                  child: Text('F R E E',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {},
                                ),
                              ]),
                            )
                          : Text(''),
                      docdata.data()['account'] == "free"
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.yellow[800],
                              elevation: 20,
                              child: Column(children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text('PRO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Great For Small Teams',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Rs 399/month',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Host up to 500 participants',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('12 hours maximum group meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Unlimited 1:1 meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free 1:1 chatting and group chatting',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Voice and Video Call',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Video Conferencing Features',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Social Media Streaming',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                FlatButton(
                                  color: Colors.white,
                                  child: Text(
                                    'B U Y ',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController controller =
                                              TextEditingController();
                                          return AlertDialog(
                                            title: Text('Payment'),
                                            content: TextField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "enter your billing address"),
                                            ),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    service.dis = 'Pro Upgrade';
                                                    service.amount = 39900;
                                                    service.address =
                                                        controller.text;
                                                    service.next();

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Text('Next'))
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ]),
                            )
                          : Text(''),
                      ((docdata.data()['account'] == "free") ||
                              (docdata.data()['account'] == "pro"))
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.yellow[800],
                              elevation: 20,
                              child: Column(children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Business',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Small& Med Business',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Rs 499/month',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Host up to 1000 participants',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('meetings	24 hours group meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Unlimited 1:1 meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free 1:1 chatting and group chatting',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Voice and Video Call',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Video Conferencing Features',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Social Media Streaming',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('Social Media Streaming',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Managed Domains',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Company Branding',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                FlatButton(
                                  color: Colors.white,
                                  child: Text('B U Y',
                                      style: TextStyle(color: Colors.green)),
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TextEditingController controller =
                                              TextEditingController();
                                          return AlertDialog(
                                            title: Text('Payment'),
                                            content: TextField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "enter your billing address"),
                                            ),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    service.dis =
                                                        "Business Upgrage";
                                                    service.amount = 49900;
                                                    service.address =
                                                        controller.text;
                                                    service.next();
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: Text('Next'))
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ]),
                            )
                          : Text(''),
                      ((docdata.data()['account'] == "free") ||
                              (docdata.data()['account'] == "pro") ||
                              (docdata.data()['account'] == "bus"))
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.yellow[800],
                              elevation: 20,
                              child: Column(children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Enterprise',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Large enterprises',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Rs899/month',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Host up to 9,999 participants',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Unlimited group meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Unlimited 1:1 meetings',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free 1:1 chatting and group chatting',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Voice and Video Call',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Free Video Conferencing Features',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Social Media Streaming',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('Social Media Streaming',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Managed Domains',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Company Branding',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                FlatButton(
                                  color: Colors.white,
                                  child: Text('Contact Sales',
                                      style: TextStyle(color: Colors.green)),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/contactus');
                                  },
                                ),
                              ]),
                            )
                          : Text(''),
                    ],
                  ))));
    else
      return SpinKitPumpingHeart(color: Colors.yellow[800]);
  }
}
