class User
{
  String phonenumber;
  String name;
  String docid;
  User({this.phonenumber,this.name,this.docid});
  Map get info {
    return {
      "phonenumber":this.phonenumber,
      'name':this.name,
      'docid':this.docid,
    };
  }
}