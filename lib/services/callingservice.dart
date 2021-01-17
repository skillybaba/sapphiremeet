import 'dart:async';

import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallingService {
  String channel;
  String caller;
  String recever;
  String number;
  CallingService(String channel,
      {String caller, String recever, String number}) {
    this.number = number;
    this.channel = channel;
    this.caller = caller;
    this.recever = recever;
  }
  Map<FeatureFlagEnum, bool> feature = {
    FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
    FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
    FeatureFlagEnum.INVITE_ENABLED: false,
    FeatureFlagEnum.MEETING_NAME_ENABLED: false,
    FeatureFlagEnum.MEETING_PASSWORD_ENABLED: false,
    FeatureFlagEnum.PIP_ENABLED: false,
    FeatureFlagEnum.RAISE_HAND_ENABLED: false,
    FeatureFlagEnum.TILE_VIEW_ENABLED: false,
    FeatureFlagEnum.RECORDING_ENABLED: false,
  };

  check() async {
    try {

     
        await Firebase.initializeApp();
    
        var doc2 = FirebaseFirestore.instance.doc(this.recever);
       snap=doc2.snapshots().listen((event) async { 
    var doc = FirebaseFirestore.instance.doc(this.caller);
  var data1ref = await doc.get();
        var data1 = data1ref.data();
        var data2 = event.data();
        if (((data1['connected'] == null) || (!data1['connected'])) &&
            (data1['connected'] || (!data2['connected']))) {
          JitsiMeet.closeMeeting();
          
        }});
       
     
   
 
    } catch (e) {
      print(e);
    }
  }
StreamSubscription<DocumentSnapshot> snap;
  fun() async {
    try {
      await Firebase.initializeApp();
      var doc = FirebaseFirestore.instance.doc(this.caller);
      var doc2 = FirebaseFirestore.instance.doc(this.recever);
      doc.update({'connected': false});
      doc2.update({'connected': false});
    } catch (e) {
      print(e);
    }
  }

  connect() async {
    var options = JitsiMeetingOptions();
    print(this.number);
    options.userDisplayName = this.number.replaceAll('+', '');
    options.room = this.channel;
    options.featureFlags.addAll(this.feature);
    options.videoMuted = true;

    await JitsiMeet.joinMeeting(options,
        listener: JitsiMeetingListener(
            onConferenceJoined: ({Map<dynamic, dynamic> message}) {
          check();
        }, onConferenceTerminated: ({Map<dynamic, dynamic> message}) {
          snap.cancel();
          
          fun();
        }));
  }
}
