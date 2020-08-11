import 'package:FL_Foreman/models/nurse_model.dart';

class Order {
  String id;
  String orderId;
  String demandName;
  String serverSite;
  String serverTime;
  String selfCare;
  String startTime;
  String endTime;
  String preferPrice;
  int status;
  List<Nurse> nurseList;
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
      this.times,
      this.orderId});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    demandName = json['demandName'];
    serverSite = json['serverSite'];
    serverTime = json['serverTime'];
    selfCare = json['selfCare'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    preferPrice = json['preferPrice'];
    status = json['status'];
    if (json['nurseList'] != null) {
      nurseList = new List<Nurse>();
      json['nurseList'].forEach((v) {
        nurseList.add(new Nurse.fromJson(v));
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
    data['orderId'] = this.orderId;
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
