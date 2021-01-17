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
        
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'assests/images/Logos/Sapphire_Meet_Logo-removebg.png',
              height: 270,
            ),
            LoginSub(),
          ],
        ));
  }
}
