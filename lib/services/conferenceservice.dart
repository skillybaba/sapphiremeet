import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conf_Service {
  String roomid;
  String subject;
  String username;
  String email;
  String type;
  var confinfo;
  Conf_Service(
      {String roomid,
      String subject,
      String username,
      String email,
      String type,
      var confinfo}) {
    this.roomid = roomid;
    this.subject = subject;
    this.email = email;
    this.username = username;
    this.type = type;
    this.confinfo = confinfo;
  }

  hostMeet() async {
    await Firebase.initializeApp();
    SharedPreferences inst = await SharedPreferences.getInstance();
    FirebaseFirestore ref = FirebaseFirestore.instance;
    var userref = ref.doc(inst.getString('userdocid'));
    var userefdata = await userref.get();
    if ((userefdata.data()['time'] != null) &&
        (DateTime.now().isAfter(userefdata.data()['time'].toDate())))
      await userref.update({
        'account': 'free',
        'time': DateTime.now().add(Duration(days: 1000)),
      });

    print(inst.getString('userdocid'));
    var options = JitsiMeetingOptions();
    
    print(this.roomid);
    options.room = this.roomid;
    options.subject = this.subject;
    options.userDisplayName = this.username;
    options.userEmail = this.email;
    options.videoMuted = false;
    options.audioMuted = false;

    options.featureFlags.addAll({
     
      FeatureFlagEnum.INVITE_ENABLED: false,
      FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: false,
    });

    if (userefdata.data()['account'] == 'free')
      options.featureFlags
          .putIfAbsent(FeatureFlagEnum.LIVE_STREAMING_ENABLED, () => false);
    await JitsiMeet.joinMeeting(options,
        listener: JitsiMeetingListener(
            onConferenceTerminated: ({Map<dynamic, dynamic> message}) {
          print(message);
        }, onError: (e) {
          print(e);
        }, onConferenceWillJoin: (({Map<dynamic, dynamic> message}) async {
          print('hello');
          var doc = ref.doc('meetings/SjVi5S7Qyj3iTqwFn6Od');
          var data = await userref.get();

          var ls = data.data()['roomid'];
          if (ls != null)
            ls.add(this.roomid);
          else {
            ls = [];
            ls.add(this.roomid);
          }
          userref.update({
            "roomid": ls,
          });
          if (this.type == 'join') {
            this.confinfo[this.roomid]['current']++;
            doc.update(this.confinfo);
          } else {
            await doc.update({
              this.roomid: {
                'current': 1,
                'max': userefdata.data()['account'] == 'free'
                    ? 100
                    : userefdata.data()['account'] == 'pro'
                        ? 500
                        : userefdata.data()['account'] == 'bus'
                            ? 1000
                            : userefdata.data()['account'] == 'Ent'
                                ? 100000
                                : "N/A",
              }
            });
          }
        })));
  }
}
