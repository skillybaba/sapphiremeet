 enum Chatuser{
    number,username,lastmsg,docid,dp
  }
class ChatModel {
  String number;
  String username;
  String lastmsg;
  String dp;
  String docid;
 
  ChatModel({String number, String username, String lastmsg,String docid,String dp}) {
    this.number = number;
    this.username = username;
    this.lastmsg = lastmsg;
    this.docid=docid;
    this.dp=dp;
  }
  getVal() {
    return {Chatuser.number:this.number,Chatuser.username :this.username, Chatuser.lastmsg:this.lastmsg,Chatuser.docid:this.docid,Chatuser.dp:this.dp};
  }

  setVal({String number, String username,String lastmsg,String docid}) {
    if (number != null) this.number = number;
    if (username != null) this.username = username;
    if (lastmsg != null) this.lastmsg = lastmsg;
    if (docid != null) this.docid = docid;
    return true;
  }
}
   
