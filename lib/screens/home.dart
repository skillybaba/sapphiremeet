import 'package:application/services/firebasedatabse.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './subscreens/pages/chatPannel.dart';
import './subscreens/pages/Confrence.dart';
import './subscreens/pages/calling.dart';
import './subscreens/pages/status.dart';
import 'package:application/services/authvals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List check = [0];
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  PageController controller = PageController(initialPage: 2);
  logout() async {
    await AuthVals().deleteVals('userinfo', 'auth');
    Navigator.pushReplacementNamed(context, '/');
  }

  String dp;
  SharedPreferences pref;
  void prefs() async {
    pref = await SharedPreferences.getInstance();
    setState(() {});
  }

  void initState() {
    super.initState();
    prefs();
  }

  void dispose() {
    super.dispose();
  }

  var info;
  var flag = false;
  getDp() async {
    if (pref != null) {
      var ref = FireBaseDataBase(number: pref.getStringList('your info')[0]);
      await ref.fetchDP();
      dp = ref.dp;
      if (dp != null)
        setState(() {
          flag = true;
        });
    }
  }

  bool ff = true;
  int i = 0;
  @override
  Widget build(BuildContext context) {
    if (!flag) getDp();
    return Scaffold(
      key: key,
      drawer: Drawer(
          child: Column(children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.yellow[800],
          ),
          child: Container(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Row(
                children: [
                  dp != null
                      ? Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FlatButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    child: Center(
                                        child: Dialog(
                                            child: Column(
                                      children: [
                                        SizedBox(height: 180),
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              ImagePicker picker =
                                                  ImagePicker();
                                              if (await Permission.photos
                                                  .request()
                                                  .isGranted) {
                                                var image =
                                                    await picker.getImage(
                                                        source: ImageSource
                                                            .gallery);
                                                var crop = await ImageCropper
                                                    .cropImage(
                                                        sourcePath: image.path,
                                                        aspectRatioPresets: [
                                                          CropAspectRatioPreset
                                                              .square,
                                                          CropAspectRatioPreset
                                                              .ratio3x2,
                                                          CropAspectRatioPreset
                                                              .original,
                                                          CropAspectRatioPreset
                                                              .ratio4x3,
                                                          CropAspectRatioPreset
                                                              .ratio16x9
                                                        ],
                                                        androidUiSettings: AndroidUiSettings(
                                                            toolbarTitle:
                                                                'Cropper',
                                                            toolbarColor: Colors
                                                                .deepOrange,
                                                            toolbarWidgetColor:
                                                                Colors.white,
                                                            initAspectRatio:
                                                                CropAspectRatioPreset
                                                                    .original,
                                                            lockAspectRatio:
                                                                false),
                                                        iosUiSettings:
                                                            IOSUiSettings(
                                                          minimumAspectRatio:
                                                              1.0,
                                                        ));

                                                await FireBaseDataBase(
                                                        number:
                                                            pref.getStringList(
                                                                'your info')[0])
                                                    .addDP(
                                                  crop,
                                                );
                                                setState(() {
                                                  ff = false;
                                                  flag = false;
                                                });
                                              }
                                            },
                                            child: Text("From Gallery",
                                                style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              ImagePicker picker =
                                                  ImagePicker();

                                              var image = await picker.getImage(
                                                  source: ImageSource.camera);
                                              var crop =
                                                  await ImageCropper.cropImage(
                                                      sourcePath: image.path,
                                                      aspectRatioPresets: [
                                                        CropAspectRatioPreset
                                                            .square,
                                                        CropAspectRatioPreset
                                                            .ratio3x2,
                                                        CropAspectRatioPreset
                                                            .original,
                                                        CropAspectRatioPreset
                                                            .ratio4x3,
                                                        CropAspectRatioPreset
                                                            .ratio16x9
                                                      ],
                                                      androidUiSettings:
                                                          AndroidUiSettings(
                                                              toolbarTitle:
                                                                  'Cropper',
                                                              toolbarColor: Colors
                                                                  .deepOrange,
                                                              toolbarWidgetColor:
                                                                  Colors.white,
                                                              initAspectRatio:
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                              lockAspectRatio:
                                                                  false),
                                                      iosUiSettings:
                                                          IOSUiSettings(
                                                        minimumAspectRatio: 1.0,
                                                      ));

                                              await FireBaseDataBase(
                                                      number:
                                                          pref.getStringList(
                                                              'your info')[0])
                                                  .addDP(
                                                crop,
                                              );

                                              setState(() {
                                                ff = false;
                                                flag = false;
                                                this.i++;
                                              });
                                            },
                                            child: Text(
                                              "From Camera",
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ))));
                              },
                              child: CircularProfileAvatar('',
                                  key: Key(this.i.toString()),
                                  child: Image(
                                    image: NetworkImage(dp),
                                  ))))
                      : IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                child: Center(
                                    child: Dialog(
                                        child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                    ),
                                    FlatButton(
                                        onPressed: () async {
                                          ImagePicker picker = ImagePicker();
                                          if (await Permission.photos
                                              .request()
                                              .isGranted) {
                                            var image = await picker.getImage(
                                                source: ImageSource.gallery);
                                            var crop =
                                                await ImageCropper.cropImage(
                                                    sourcePath: image.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .square,
                                                      CropAspectRatioPreset
                                                          .ratio3x2,
                                                      CropAspectRatioPreset
                                                          .original,
                                                      CropAspectRatioPreset
                                                          .ratio4x3,
                                                      CropAspectRatioPreset
                                                          .ratio16x9
                                                    ],
                                                    androidUiSettings:
                                                        AndroidUiSettings(
                                                            toolbarTitle:
                                                                'Cropper',
                                                            toolbarColor: Colors
                                                                .deepOrange,
                                                            toolbarWidgetColor:
                                                                Colors.white,
                                                            initAspectRatio:
                                                                CropAspectRatioPreset
                                                                    .original,
                                                            lockAspectRatio:
                                                                false),
                                                    iosUiSettings:
                                                        IOSUiSettings(
                                                      minimumAspectRatio: 1.0,
                                                    ));

                                            await FireBaseDataBase(
                                                    number: pref.getStringList(
                                                        'your info')[0])
                                                .addDP(
                                              crop,
                                            );
                                            setState(() {
                                              ff = false;
                                              flag = false;
                                            });
                                          }
                                        },
                                        child: Text("From Gallery",
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold))),
                                    FlatButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          ImagePicker picker = ImagePicker();

                                          var image = await picker.getImage(
                                              source: ImageSource.camera);
                                          var crop =
                                              await ImageCropper.cropImage(
                                                  sourcePath: image.path,
                                                  aspectRatioPresets: [
                                                    CropAspectRatioPreset
                                                        .square,
                                                    CropAspectRatioPreset
                                                        .ratio3x2,
                                                    CropAspectRatioPreset
                                                        .original,
                                                    CropAspectRatioPreset
                                                        .ratio4x3,
                                                    CropAspectRatioPreset
                                                        .ratio16x9
                                                  ],
                                                  androidUiSettings:
                                                      AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Cropper',
                                                          toolbarColor:
                                                              Colors.deepOrange,
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                  iosUiSettings: IOSUiSettings(
                                                    minimumAspectRatio: 1.0,
                                                  ));

                                          await FireBaseDataBase(
                                                  number: pref.getStringList(
                                                      'your info')[0])
                                              .addDP(
                                            crop,
                                          );

                                          setState(() {
                                            ff = false;
                                            flag = false;
                                          });
                                        },
                                        child: Text("From Camera",
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ))));
                          },
                          icon: Icon(Icons.account_circle),
                          iconSize: 80,
                          color: Colors.white,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    pref.getStringList('your info')[1],
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ],
              )),
        ),
        RaisedButton.icon(
            color: Colors.yellow[800],
            onPressed: () {},
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            label: Text(
              'A B O U T  U S',
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton.icon(
            color: Colors.yellow[800],
            onPressed: () {},
            icon: Icon(
              Icons.contact_support_sharp,
              color: Colors.white,
            ),
            label: Text(
              'C O N T A C T  U S',
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton.icon(
            color: Colors.yellow[800],
            onPressed: () {
              Navigator.pushNamed(context,'/Calculator');
            },
            icon: Icon(
              Icons.calculate,
              color: Colors.white,
            ),
            label: Text(
              'C A L C U L A T O R',
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton.icon(
            color: Colors.yellow[800],
            onPressed: () {
              Navigator.pushNamed(context, '/setting', arguments: {
                'data': pref.getStringList('your info'),
                'url': this.dp,
              });
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: Text(
              'S E T T I N G S',
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton.icon(
            color: Colors.yellow[800],
            onPressed: () {
              Navigator.pushNamed(context, '/payments', arguments: {
                'info': pref.getStringList('your info'),
                'userdocid': pref.getString('userdocid'),
              });
            },
            icon: Icon(
              Icons.upgrade_outlined,
              color: Colors.white,
            ),
            label: Text(
              'U P G R A D E',
              style: TextStyle(color: Colors.white),
            )),
        RaisedButton.icon(
          color: Colors.yellow[800],
          onPressed: logout,
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          label: Text(
            "L O G O U T",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ])),
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                controller.animateToPage(3,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
                check[0] = 3232;
              },
              child: Icon(Icons.rounded_corner, size: 30, color: Colors.white))
        ],
        bottom: PreferredSize(
            preferredSize: Size(40, 60),
            child: Row(children: [
              Container(
                  margin: EdgeInsets.only(left: 21),
                  child: FlatButton.icon(
                    color: Colors.yellow[800],
                    onPressed: () {
                      controller.animateToPage(0,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn);
                      check[0] = 0;
                    },
                    icon: Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      'Chat',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
              FlatButton.icon(
                  color: Colors.yellow[800],
                  onPressed: () {
                    controller.animateToPage(1,
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn);
                    check[0] = 3232;
                  },
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text('Call',
                      style: TextStyle(color: Colors.white, fontSize: 15))),
              FlatButton.icon(
                  color: Colors.yellow[800],
                  onPressed: () {
                    controller.animateToPage(2,
                        duration: Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn);
                    check[0] = 3232;
                  },
                  icon: Icon(
                    Icons.group,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text('Conference',
                      style: TextStyle(color: Colors.white, fontSize: 15))),
            ])),
        backgroundColor: Colors.yellow[800],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        leading: FlatButton(
            onPressed: () {
              key.currentState.openDrawer();
            },
            child: Icon(Icons.menu, color: Colors.white)),
        title: Text('Sapphire Meet'),
        centerTitle: true,
      ),
      body: PageView(
        controller: controller,
        children: [
          Chat(check: check),
          Calling(check: check),
          Confrence(
            check: check,
          ),
          Status(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, '/contacts');
          print('done');
          check[0] = 343;
        },
        child: Icon(Icons.group_add_outlined),
        backgroundColor: Colors.yellow[800],
      ),
    );
  }
}
