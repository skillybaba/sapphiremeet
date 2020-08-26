class StatusModel {
  String name;
  String number;
  StatusModel({String name, String number}) {
    this.name = name;
    this.number = number;
  }
  getVal() {
    return [this.name, this.number];
  }

  setVal({String name, String number}) {
    if(name!=null)
    this.name = name;
    if(number!=null)
    this.number = number;
    return true;
  }
}
