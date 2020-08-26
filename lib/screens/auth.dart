import 'package:flutter/material.dart';
import './subscreens/pages/login.dart';
import './subscreens/pages/signup.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  PageController controller = PageController(initialPage: 0);
  GlobalKey key = GlobalKey();
  var icon = Icons.add;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          Login(),
          SignUp(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[800],
        onPressed: () {
          if (controller.page == 0) {
            controller.animateToPage(1,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
            setState(() {
              icon = Icons.arrow_back_ios;
            });
          } else {
            controller.animateToPage(0,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
            setState(() {
              icon = Icons.add;
            });
          }
        },
        tooltip: 'Join A Meeting as a Guest',
        child: Icon(icon),
      ),
    );
  }
}
