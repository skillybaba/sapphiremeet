import 'package:application/services/firebasedatabse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:application/services/authvals.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var name = TextEditingController();
  DateTime dob;
  Map data;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text('Give the Details'),
          centerTitle: true,
        ),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(40),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    hintText: 'What People Should Call You'),
              )),
          FlatButton.icon(
              onPressed: () {
                DatePicker.showDatePicker(context, showTitleActions: true,
                    onConfirm: (date) {
                  setState(() {
                    dob = date;
                  });
                }, currentTime: dob,minTime: DateTime(1947));
              },
              icon: Icon(
                Icons.date_range,
                color: Colors.yellow[800],
                size: 40,
              ),
              label: Text('Enter Your DOB',
                  style: TextStyle(
                    color: Colors.yellow[800],
                  ))),
          SizedBox(
            height: 30,
          ),
          FlatButton.icon(
            onPressed: () async {
              try {
                AuthVals authVals = AuthVals();
                authVals.auth = true;
                print(data);
                var firedata = FireBaseDataBase(
                    number: data['number'], username: name.text);
                await firedata.addUser();
                
                await authVals.setVal(data['number'], name.text);
                Navigator.pushReplacementNamed(context, '/home');
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(
              Icons.arrow_right,
              color: Colors.yellow[800],
              size: 40,
            ),
            label: Text('Next',
                style: TextStyle(
                  color: Colors.yellow[800],
                )),
          )
        ]));
  }
}
