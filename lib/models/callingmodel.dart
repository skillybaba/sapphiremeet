class CallingModel {
  String number;
  String name;
  String type;
  String docid;
  CallingModel({String number, String name, String type, String docid}) {
    this.number = number;
    this.name = name;
    this.type = type;
    this.docid = docid;
  }
  getVal() {
    return [this.number, this.name, this.type,this.docid];
  }

  setVal({String number, String name,String type,String docid}) {
    if (number != null) this.number = number;
    if (name != null) this.name = name;
    if (type != null) this.type = type;
    if (docid != null) this.docid = docid;
    return true;
  }
}
