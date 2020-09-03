import 'package:shared_preferences/shared_preferences.dart';

class AuthVals {
  String number;
  String name;
  var auth = false;
  Future<bool> setVal(number, name) async {
    var sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setStringList('userinfo', [number, name]);
    await sharedpref.setBool('auth', true);
    return true;
  }

  Future<bool> setAuth() async {
    var pref = await SharedPreferences.getInstance();
    await pref.setBool('auth', true);
    return true;
  }

  Future<List> getVals(key, authkey) async {
    var sharedpref = await SharedPreferences.getInstance();

    var vals = sharedpref.getStringList(key);

    var authval = sharedpref.getBool(authkey);
    return [vals, authval];
  }

  Future<bool> deleteVals(key, authkey) async {
    var sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setStringList(key, []);
    await sharedpref.setBool(authkey, false);
    return true;
  }
}
