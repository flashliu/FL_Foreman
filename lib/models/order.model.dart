class Order {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  String userId;
  String nurseTypeId;
  String nurseTypeName;
  String areaId;
  String areaName;
  String address;
  String contactName;
  String contactPhone;
  String patientDescription;
  String nurseRequire;
  int price;
  int unit;
  String startTime;
  String endTime;
  int emergency;
  int status;
  String nurseLevel;
  String patientName;
  int patientSex;
  String serverTime;
  String totalTime;
  String preferPrice;
  String longitude;
  String latitude;
  String patientIdentId;
  int needType;
  String bidStartTime;
  String bidEndTime;
  int commend;
  int bidStatus;
  String orderId;
  int bidMoney;
  int orderStatus;
  String needId;
  String nurseId;
  String orderNumber;
  int amount;
  int orderType;
  String realName;
  String avatar;
  String phone;
  String myAddr;
  String myLevel;
  String myType;

  Order(
      {this.id,
      this.createTime,
      this.updateTime,
      this.deleted,
      this.userId,
      this.nurseTypeId,
      this.nurseTypeName,
      this.areaId,
      this.areaName,
      this.address,
      this.contactName,
      this.contactPhone,
      this.patientDescription,
      this.nurseRequire,
      this.price,
      this.unit,
      this.startTime,
      this.endTime,
      this.emergency,
      this.status,
      this.nurseLevel,
      this.patientName,
      this.patientSex,
      this.serverTime,
      this.totalTime,
      this.preferPrice,
      this.longitude,
      this.latitude,
      this.patientIdentId,
      this.needType,
      this.bidStartTime,
      this.bidEndTime,
      this.commend,
      this.bidStatus,
      this.orderId,
      this.bidMoney,
      this.orderStatus,
      this.needId,
      this.nurseId,
      this.orderNumber,
      this.amount,
      this.orderType,
      this.realName,
      this.avatar,
      this.phone,
      this.myAddr,
      this.myLevel,
      this.myType});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    userId = json['userId'];
    nurseTypeId = json['nurseTypeId'];
    nurseTypeName = json['nurseTypeName'];
    areaId = json['areaId'];
    areaName = json['areaName'];
    address = json['address'];
    contactName = json['contactName'];
    contactPhone = json['contactPhone'];
    patientDescription = json['patientDescription'];
    nurseRequire = json['nurseRequire'];
    price = json['price'];
    unit = json['unit'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    emergency = json['emergency'];
    status = json['status'];
    nurseLevel = json['nurseLevel'];
    patientName = json['patientName'];
    patientSex = json['patientSex'];
    serverTime = json['serverTime'];
    totalTime = json['totalTime'];
    preferPrice = json['preferPrice'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    patientIdentId = json['patientIdentId'];
    needType = json['needType'];
    bidStartTime = json['bidStartTime'];
    bidEndTime = json['bidEndTime'];
    commend = json['commend'];
    bidStatus = json['bidStatus'];
    orderId = json['orderId'];
    bidMoney = json['bidMoney'];
    orderStatus = json['orderStatus'];
    needId = json['needId'];
    nurseId = json['nurseId'];
    orderNumber = json['orderNumber'];
    amount = json['amount'];
    orderType = json['orderType'];
    realName = json['realName'];
    avatar = json['avatar'];
    phone = json['phone'];
    myAddr = json['myAddr'];
    myLevel = json['myLevel'];
    myType = json['myType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['userId'] = this.userId;
    data['nurseTypeId'] = this.nurseTypeId;
    data['nurseTypeName'] = this.nurseTypeName;
    data['areaId'] = this.areaId;
    data['areaName'] = this.areaName;
    data['address'] = this.address;
    data['contactName'] = this.contactName;
    data['contactPhone'] = this.contactPhone;
    data['patientDescription'] = this.patientDescription;
    data['nurseRequire'] = this.nurseRequire;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['emergency'] = this.emergency;
    data['status'] = this.status;
    data['nurseLevel'] = this.nurseLevel;
    data['patientName'] = this.patientName;
    data['patientSex'] = this.patientSex;
    data['serverTime'] = this.serverTime;
    data['totalTime'] = this.totalTime;
    data['preferPrice'] = this.preferPrice;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['patientIdentId'] = this.patientIdentId;
    data['needType'] = this.needType;
    data['bidStartTime'] = this.bidStartTime;
    data['bidEndTime'] = this.bidEndTime;
    data['commend'] = this.commend;
    data['bidStatus'] = this.bidStatus;
    data['orderId'] = this.orderId;
    data['bidMoney'] = this.bidMoney;
    data['orderStatus'] = this.orderStatus;
    data['needId'] = this.needId;
    data['nurseId'] = this.nurseId;
    data['orderNumber'] = this.orderNumber;
    data['amount'] = this.amount;
    data['orderType'] = this.orderType;
    data['realName'] = this.realName;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
    data['myAddr'] = this.myAddr;
    data['myLevel'] = this.myLevel;
    data['myType'] = this.myType;
    return data;
  }
}
