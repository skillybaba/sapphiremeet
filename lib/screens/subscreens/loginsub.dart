import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

class LoginSub extends StatefulWidget {
  @override
  _LoginSubState createState() => _LoginSubState();
}

class _LoginSubState extends State<LoginSub> {
  TextEditingController controller = TextEditingController();
  String s1 = '+91';
  Future<bool> loginuser(String number, context) async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;

      auth.verifyPhoneNumber(
          timeout: Duration(minutes: 1),
          phoneNumber: number,
          verificationCompleted: (var credential) async {
            var result = await auth.signInWithCredential(credential);
            var user = result.user;
            if (user != null) {
              Navigator.popAndPushNamed(context, '/home');
            } else {
              print('error');
            }
          },
          verificationFailed: (var exception) {
            print(exception);
          },
          codeSent: (String verification, [int forceresendtoken]) {
            showDialog(
                context: context,
                builder: (context) {
                  var controllercode = TextEditingController();

                  return AlertDialog(
                    title: Text('Enter the OTP'),
                    actions: [
                      FlatButton(
                        onPressed: () async {
                          var credential = PhoneAuthProvider.credential(
                              verificationId: verification,
                              smsCode: controllercode.text.trim());
                              var result = await auth.signInWithCredential(credential);
            var user = result.user;
            if (user != null) {
              Navigator.popAndPushNamed(context, '/home');
            } else {
              print('error');
            }

                        },
                        child: Text('Check OTP'),
                      )
                    ],
                    content: TextField(
                      controller: controllercode,
                      onEditingComplete: () async {
                        var credential = PhoneAuthProvider.credential(
                              verificationId: verification,
                              smsCode: controllercode.text.trim());
                              var result = await auth.signInWithCredential(credential);
            var user = result.user;
            if (user != null) {
              Navigator.popAndPushNamed(context, '/home');
            } else {
              print('error');
            }
                      },
                    ),
                  );
                });
          },
          codeAutoRetrievalTimeout: (String s) {
            print(s);
          });
      return true;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: Column(
          children: [
            CountryCodePicker(
              onChanged: (value) {
                s1 = value.dialCode;
                print(s1);
              },
              initialSelection: '+91',
            ),
            TextField(
              controller: controller,
              autocorrect: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Enter Your Phone no.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            SizedBox(height: 30),
            FlatButton.icon(
                onPressed: () {
                  String number = s1.toString() + controller.text;
                  print(number);
                  loginuser(number, context);
                },
                icon: Icon(Icons.login),
                label: Text('Login'))
          ],
        ));
  }
}
