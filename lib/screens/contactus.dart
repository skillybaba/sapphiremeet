import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactus extends StatefulWidget {
  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text('Contact Us'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                height: 700,
                padding: EdgeInsets.all(40),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[800])),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controller2,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[800])),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controller3,
                      decoration: InputDecoration(
                        labelText: 'Email Id',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[800])),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controller4,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow[800])),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton.icon(
                      elevation: 30,
                      onPressed: () {
                        launch(Uri(
                            scheme: 'mailto',
                            path: 'sapphiremeet@gmail.com',
                            queryParameters: {
                              'subject': 'contactus',
                              'body': '''name : ${controller1.text} 
              contact number : ${controller2.text}
              email : ${controller3.text}
              message : ${controller4.text}
               '''
                            }).toString());
                      },
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.yellow[800],
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        launch('tel:+919084306680');
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      color: Colors.yellow[800],
                      elevation: 50,
                      label: Text(
                        "+919084306680",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(children: [
                      FlatButton(
                        minWidth: 30,
                          onPressed: () {
                            launch('https://www.facebook.com/sapphiremeet');
                          },
                          child: Image.asset(
                            'assests/images/facebook.png',
                            width: 35,
                          )),
                      FlatButton(
                        minWidth: 20,
                          onPressed: () {
                            launch('https://www.instagram.com/sapphiremeet/');
                          },
                          child: Image.asset(
                            'assests/images/instagram.png',
                            width: 35,
                          )),
                      FlatButton(
                        minWidth: 20,
                          onPressed: () {
                            launch(
                                'https://www.linkedin.com/company/sapphire-meet/');
                          },
                          child: Image.asset(
                            'assests/images/linkedin.png',
                            width: 35,
                          )),
                          FlatButton(
                      minWidth: 20,
                        onPressed: () {
                          launch('https://twitter.com/MeetSapphire');
                        },
                        child: Image.asset(
                          'assests/images/twitter.jpg',
                          width: 35,
                        )),
                    ]),
                    
                  ],
                )))));
  }
}
