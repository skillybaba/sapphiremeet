import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:application/services/authvals.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // Future<bool> gg() async {
  //   var pref = await SharedPreferences.getInstance();
  //   await pref.setStringList('userinfo', []);
  //   await pref.setBool('auth', false);
  // }

  Future<bool> getVals() async {
    var authvals = AuthVals();
    var prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userinfo') && prefs.containsKey('auth')) {
      var vals = await authvals.getVals('userinfo', 'auth');
      if (vals[1] == true) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'userbasic': vals[0],
        });
      } else {
        Navigator.pushReplacementNamed(context, '/auth');
        return false;
      }

      return true;
    }
    Navigator.pushReplacementNamed(context, '/auth');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    getVals();
    
    return Container(
      child: Center(
        child: SpinKitChasingDots(color: Colors.yellow[800], size: 50),
      ),
    );
  }
}
