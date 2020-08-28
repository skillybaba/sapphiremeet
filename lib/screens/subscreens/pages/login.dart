import 'package:flutter/material.dart';
import '../loginsub.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'assests/images/Logos/IMG-20200821-WA0005(1).jpg',
              height: 270,
            ),
            LoginSub(),
          ],
        ));
  }
}
