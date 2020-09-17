class Need {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  String userId;
  String notes;
  String demandName;
  String serverSite;
  String serverTime;
  String selfCare;
  String beNursedId;
  double price;
  int unit;
  String startTime;
  String endTime;
  int status;
  String totalTime;
  String preferPrice;
  int commend;
  String realName;
  String identId;
  String address;
  String area;
  String phone;
  int defaultState;
  int peopleNumber;
  String orderNumber;
  double amount;

  Need({
    this.id,
    this.createTime,
    this.updateTime,
    this.deleted,
    this.userId,
    this.notes,
    this.demandName,
    this.serverSite,
    this.serverTime,
    this.selfCare,
    this.beNursedId,
    this.price,
    this.unit,
    this.startTime,
    this.endTime,
    this.status,
    this.totalTime,
    this.preferPrice,
    this.commend,
    this.realName,
    this.identId,
    this.address,
    this.area,
    this.phone,
    this.defaultState,
    this.peopleNumber,
    this.orderNumber,
    this.amount,
  });

  Need.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    userId = json['userId'];
    notes = json['notes'];
    demandName = json['demandName'];
    serverSite = json['serverSite'];
    serverTime = json['serverTime'];
    selfCare = json['selfCare'];
    beNursedId = json['beNursedId'];
    price = json['price'];
    unit = json['unit'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'];
    totalTime = json['totalTime'];
    preferPrice = json['preferPrice'];
    commend = json['commend'];
    realName = json['realName'];
    identId = json['identId'];
    address = json['address'];
    area = json['area'];
    phone = json['phone'];
    defaultState = json['defaultState'];
    peopleNumber = json['peopleNumber'];
    orderNumber = json['orderNumber'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['userId'] = this.userId;
    data['notes'] = this.notes;
    data['demandName'] = this.demandName;
    data['serverSite'] = this.serverSite;
    data['serverTime'] = this.serverTime;
    data['selfCare'] = this.selfCare;
    data['beNursedId'] = this.beNursedId;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['status'] = this.status;
    data['totalTime'] = this.totalTime;
    data['preferPrice'] = this.preferPrice;
    data['commend'] = this.commend;
    data['realName'] = this.realName;
    data['identId'] = this.identId;
    data['address'] = this.address;
    data['area'] = this.area;
    data['phone'] = this.phone;
    data['defaultState'] = this.defaultState;
    data['peopleNumber'] = this.peopleNumber;
    data['orderNumber'] = this.orderNumber;
    data['amount'] = this.amount;
    return data;
  }
}
