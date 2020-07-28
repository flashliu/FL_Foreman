class Order {
  String id;
  String demandName;
  String serverSite;
  String serverTime;
  String selfCare;
  String startTime;
  String endTime;
  String preferPrice;
  int status;
  List<NurseList> nurseList;
  BeNursed beNursed;
  String createTime;
  String notes;
  double price;
  int sumtime;
  int times;

  Order(
      {this.id,
      this.demandName,
      this.serverSite,
      this.serverTime,
      this.selfCare,
      this.startTime,
      this.endTime,
      this.preferPrice,
      this.status,
      this.nurseList,
      this.beNursed,
      this.createTime,
      this.notes,
      this.price,
      this.sumtime,
      this.times});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    demandName = json['demandName'];
    serverSite = json['serverSite'];
    serverTime = json['serverTime'];
    selfCare = json['selfCare'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    preferPrice = json['preferPrice'];
    status = json['status'];
    if (json['nurseList'] != null) {
      nurseList = new List<NurseList>();
      json['nurseList'].forEach((v) {
        nurseList.add(new NurseList.fromJson(v));
      });
    }
    beNursed = json['beNursed'] != null ? new BeNursed.fromJson(json['beNursed']) : null;
    createTime = json['createTime'];
    notes = json['notes'];
    price = json['price'];
    sumtime = json['sumtime'];
    times = json['times'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['demandName'] = this.demandName;
    data['serverSite'] = this.serverSite;
    data['serverTime'] = this.serverTime;
    data['selfCare'] = this.selfCare;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['preferPrice'] = this.preferPrice;
    data['status'] = this.status;
    if (this.nurseList != null) {
      data['nurseList'] = this.nurseList.map((v) => v.toJson()).toList();
    }
    if (this.beNursed != null) {
      data['beNursed'] = this.beNursed.toJson();
    }
    data['createTime'] = this.createTime;
    data['notes'] = this.notes;
    data['price'] = this.price;
    data['sumtime'] = this.sumtime;
    data['times'] = this.times;
    return data;
  }
}

class NurseList {
  int age;
  String nurseId;
  String extraPrice;
  String starNum;
  String realName;
  int sex;
  int workTimes;
  String headImg;
  String nurseLevel;

  NurseList(
      {this.age,
      this.nurseId,
      this.extraPrice,
      this.starNum,
      this.realName,
      this.sex,
      this.workTimes,
      this.headImg,
      this.nurseLevel});

  NurseList.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    nurseId = json['nurseId'];
    extraPrice = json['extraPrice'];
    starNum = json['starNum'];
    realName = json['realName'];
    sex = json['sex'];
    workTimes = json['workTimes'];
    headImg = json['headImg'];
    nurseLevel = json['nurseLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['nurseId'] = this.nurseId;
    data['extraPrice'] = this.extraPrice;
    data['starNum'] = this.starNum;
    data['realName'] = this.realName;
    data['sex'] = this.sex;
    data['workTimes'] = this.workTimes;
    data['headImg'] = this.headImg;
    data['nurseLevel'] = this.nurseLevel;
    return data;
  }
}

class BeNursed {
  String realName;
  String area;
  String address;
  String phone;

  BeNursed({this.realName, this.area, this.address, this.phone});

  BeNursed.fromJson(Map<String, dynamic> json) {
    realName = json['realName'];
    area = json['area'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['realName'] = this.realName;
    data['area'] = this.area;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
