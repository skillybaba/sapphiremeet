import 'package:flutter/material.dart';
import 'package:application/services/firebasedatabse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactView extends StatefulWidget {
  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  List contacts;
  bool flag1 = false;
  bool flag = false;
  Future<bool> getThings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print((prefs.containsKey('contact fetched')));
      if ((prefs.containsKey('contact fetched') && (!flag1))) {
        List names = prefs.getStringList('contact name').toSet().toList();
        List docid = prefs.getStringList('contact docid').toSet().toList();
        List list = prefs.getStringList('contact list').toSet().toList();
        print('$list, $docid, $names');

        int k = 0;

        contacts = [list, docid, names];
      } else {
        contacts = await FireBaseDataBase().fetchContact();
      }
     
      setState(() {
        flag = true;
      });
      return true;
    } catch (e) {
      print(e);
    }
  }

  fun(String number, String docid, String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(number))
      await pref.setStringList(number, [docid, name]);
  }

  @override
  Widget build(BuildContext context) {
    if (!flag) getThings();
    if (flag)
      return Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  RaisedButton(
                    color: Colors.yellow[800],
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        flag1 = true;
                        flag = false;
                      });
                    },
                    child: Icon(Icons.refresh),
                  )
                ],
                leading: FlatButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/home');
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)),
                floating: true,
                pinned: true,
                expandedHeight: 120.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Contacts'),
                ),
                backgroundColor: Colors.yellow[800],
              ),
              SliverList(delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < contacts[0].length) {
                    fun(contacts[0][index], contacts[1][index],
                        contacts[2][index]);
                    print(contacts[1][index]);
                    return Container(
                        margin: EdgeInsets.all(10),
                        color: Colors.yellow[800],
                        padding: EdgeInsets.all(10),
                        child: FlatButton.icon(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '/chatpannel',
                                  arguments: {
                                    'number': contacts[0][index],
                                    'docid': contacts[1][index],
                                    'name': contacts[2][index],
                                  });
                            },
                            icon: Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.contact_mail,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            label: Column(children: [
                              Text(
                                '${contacts[0][index]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Text('${contacts[2][index]}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15))
                            ])));
                  }
                },
              )),
            ],
          ));
    else
      return Center(
          child: SpinKitCircle(
        color: Colors.yellow[800],
      ));
  }
}
