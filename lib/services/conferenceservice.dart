import 'package:jitsi_meet/feature_flag/feature_flag_helper.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';

class Conf_Service {
  String roomid;
  String subject;
  String username;
  String email;
  Conf_Service({String roomid, String subject, String username, String email}) {
    this.roomid = roomid;
    this.subject = subject;
    this.email = email;
    this.username = username;
  }

  hostMeet() async {
    var options = JitsiMeetingOptions();
    options.room = this.roomid;
    options.subject = this.subject;
    options.userDisplayName = this.username;
    options.userEmail = this.email;
    options.videoMuted = false;
    options.audioMuted = false;
    options.featureFlags
        .putIfAbsent(FeatureFlagEnum.CALENDAR_ENABLED, () => true);
    await JitsiMeet.joinMeeting(
      options,
    );
  }
}
