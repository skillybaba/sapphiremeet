class ChatModel {
  String number;
  String username;
  String lastmsg;
  String docid;
  ChatModel({String number, String username, String lastmsg,String docid}) {
    this.number = number;
    this.username = username;
    this.lastmsg = lastmsg;
    this.docid=docid;
  }
  getVal() {
    return [this.number, this.username, this.lastmsg,this.docid];
  }

  setVal({String number, String username,String lastmsg,String docid}) {
    if (number != null) this.number = number;
    if (username != null) this.username = username;
    if (lastmsg != null) this.lastmsg = lastmsg;
    if (docid != null) this.docid = docid;
    return true;
  }
}
   
