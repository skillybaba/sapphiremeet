import 'package:flutter/material.dart';
import 'package:application/services/firebasedatabse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContactView extends StatefulWidget {
  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  List contacts;
  Future<bool> getThings() async {
    contacts = await FireBaseDataBase().fetchContact();

    setState(() {
      flag = true;
    });
    return true;
  }

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    if (!flag) getThings();
    if (flag)
      return Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
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
                  if (index < contacts[0].length)
                    return Container(
                        padding: EdgeInsets.all(20),
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
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.contact_mail,
                                size: 30,
                                color: Colors.yellow[800],
                              ),
                            ),
                            label: Column(children: [
                              Text(
                                '${contacts[0][index]}',
                                style: TextStyle(
                                    color: Colors.yellow[800], fontSize: 20),
                              ),
                              Text('${contacts[2][index]}',
                                  style: TextStyle(
                                      color: Colors.yellow[800], fontSize: 20))
                            ])));
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
