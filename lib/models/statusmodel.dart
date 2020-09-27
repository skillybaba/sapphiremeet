class StatusModel {
  String name;
  String number;
  String docid;
  String link;
  StatusModel({String name, String number, String docid, String link}) {
    this.name = name;
    this.number = number;
    this.docid = docid;
    this.link = link;
  }
  getVal() {
    return [this.name, this.number, this.docid,this.link];
  }

  setVal({String name, String number, String docid,String link}) {
    if (name != null) this.name = name;
    if (number != null) this.number = number;
    if (docid != null) this.docid = docid;
    if (link != null) this.link = link;
    return true;
  }
}
