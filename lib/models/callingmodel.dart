class CallingModel {
  String number;
  String name;
  CallingModel({String number, String name}) {
    this.number = number;
    this.name = name;
  }
  getVal() {
    return [this.number, this.name];
  }

  setVal({String number, String name}) {
    if(number!=null)
    this.number = number;
    if(name!=null)
    this.name=name;
    return true;
  }
}
