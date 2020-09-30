import 'package:application/services/paymentservice.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map data;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    PaymentService service = PaymentService(
        address: '',
        api: "rzp_live_OJXiAs7A475Myu",
        number: data['info'][0],
        userdocid: data['userdocid'],
        amount: 0);
    return Scaffold(
        appBar: AppBar(
          title: Text('upgrade'),
          centerTitle: true,
          backgroundColor: Colors.yellow[800],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 60, top: 20),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.yellow[800],
                      elevation: 20,
                      child: Column(children: [
                        SizedBox(height: 30,),
                        Text('BASIC',style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                         SizedBox(height: 30,),
                        Text('Personal Meeting',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                       SizedBox(height: 10,),
                        Text('Free',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text('Host up to 130 participants',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text('1 hour group meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text('Unlimited 1:1 meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                       SizedBox(height: 10,),
                        Text('Free 1:1 chatting and group chatting',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text('Free Voice and Video Call',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text('Free Video Conferencing Features',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        FlatButton(
                          child: Text('F R E E',style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                          onPressed: () {},
                        ),
                      ]),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.yellow[800],
                      elevation: 20,
                      child: Column(children: [
                        SizedBox(height: 30,),
                        Text('PRO',style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                        SizedBox(height: 30,),
                        Text('Great For Small Teams',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Rs 399/-',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Host up to 500 participants',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('12 hours maximum group meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Unlimited 1:1 meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free 1:1 chatting and group chatting',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free Voice and Video Call',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free Video Conferencing Features',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Social Media Streaming',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        FlatButton(
                          color: Colors.white,
                          child: Text('B U Y',style: TextStyle(color:Colors.green),),
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
                                            service.address = controller.text;
                                            service.next();

                                            Navigator.pop(context);
                                          },
                                          child: Text('Next'))
                                    ],
                                  );
                                });
                          },
                        ),
                      ]),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.yellow[800],
                      elevation: 20,
                      child: Column(children: [
                        SizedBox(height: 30,),
                        Text('Business',style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                         SizedBox(height: 30,),
                        Text('Small& Med Business',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Rs 499/-',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Host up to 1000 participants',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('meetings	24 hours group meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Unlimited 1:1 meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free 1:1 chatting and group chatting',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free Voice and Video Call',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free Video Conferencing Features',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Social Media Streaming',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        FlatButton(
                          color: Colors.white,
                          child: Text('B U Y',style: TextStyle(color:Colors.green)),
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
                                            service.dis = "Business Upgrage";
                                            service.amount = 49900;
                                            service.address = controller.text;
                                            service.next();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Next'))
                                    ],
                                  );
                                });
                          },
                        ),
                      ]),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.yellow[800],
                      elevation: 20,
                      child: Column(children: [
                        SizedBox(height: 30,),
                        Text('Enterprise',style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                         SizedBox(height: 30,),
                        Text('Large enterprises',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Rs899/-',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Host up to 9,999 participants',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Unlimited group meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text('Unlimited 1:1 meetings',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free 1:1 chatting and group chatting',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free Voice and Video Call',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Free Video Conferencing Features',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                         SizedBox(height: 10,),
                        Text('Social Media Streaming',style: TextStyle(color:Colors.white,fontSize: 13,fontWeight: FontWeight.bold)),
                        FlatButton(
                          color: Colors.white,
                          child: Text('Contact Sales',style: TextStyle(color:Colors.green)),
                          onPressed: () {},
                        ),
                      ]),
                    ),
                  ],
                ))));
  }
}
