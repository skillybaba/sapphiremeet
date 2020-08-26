class ChatModel {
  String number;
  String username;
  String lastmsg;
  ChatModel({String number, String username,String lastmsg}) {
    this.number = number;
    this.username = username;
    this.lastmsg = lastmsg;
  }
  getVal() {
    return [this.number, this.username, this.lastmsg];
  }

  setVal({String number, String username}) {
    if(number!=null)
    this.number = number;
    if(username!=null)
    this.username = username;
    if(lastmsg!=null)
    this.lastmsg = lastmsg;
    return true;
  }
}
