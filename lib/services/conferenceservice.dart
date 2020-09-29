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
    SharedPreferences inst = await SharedPreferences.getInstance();
    print(inst.getString('userdocid'));
    var options = JitsiMeetingOptions();
    options.room = this.roomid;
    options.subject = this.subject;
    options.userDisplayName = this.username;
    options.userEmail = this.email;
    options.videoMuted = false;
    options.audioMuted = false;
    options.featureFlags
        .putIfAbsent(FeatureFlagEnum.CALENDAR_ENABLED, () => true);
    await JitsiMeet.joinMeeting(options, listener: JitsiMeetingListener(
        onConferenceWillJoin: (({Map<dynamic, dynamic> message}) async {
      await Firebase.initializeApp();

      FirebaseFirestore ref = FirebaseFirestore.instance;
      var userref = ref.doc(inst.getString('userdocid'));
      var userefdata = await userref.get();
      print('hello');
      var doc = ref.doc('meetings/SjVi5S7Qyj3iTqwFn6Od');
      if (this.type == 'join') {
        this.confinfo[this.roomid]['current']++;
        doc.update(this.confinfo);
      } else {
        await doc.update({
          this.roomid: {
            'current': 1,
            'max': userefdata.data()['account'] == 'free' ? 100 : 'N/A'
          }
        });
      }
    })));
  }
}
