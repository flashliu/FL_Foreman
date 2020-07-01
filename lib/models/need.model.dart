class Need {
  String address;
  String areaId;
  String bidEndTime;
  int bidNum;
  String bidStartTime;
  String command;
  String contactName;
  String contactPhone;
  int emergency;
  String endTime;
  String latitude;
  String longitude;
  int needType;
  String nurseLevel;
  String nurseRequire;
  String nurseTypeId;
  String nurseTypeName;
  String patientDescription;
  String patientIdentId;
  String patientName;
  int patientSex;
  String preferPrice;
  int price;
  String serverTime;
  String startTime;
  int status;
  String title;
  String totalTime;
  int unit;
  String userId;

  Need(
      {this.address,
      this.areaId,
      this.bidEndTime,
      this.bidNum,
      this.bidStartTime,
      this.command,
      this.contactName,
      this.contactPhone,
      this.emergency,
      this.endTime,
      this.latitude,
      this.longitude,
      this.needType,
      this.nurseLevel,
      this.nurseRequire,
      this.nurseTypeId,
      this.nurseTypeName,
      this.patientDescription,
      this.patientIdentId,
      this.patientName,
      this.patientSex,
      this.preferPrice,
      this.price,
      this.serverTime,
      this.startTime,
      this.status,
      this.title,
      this.totalTime,
      this.unit,
      this.userId});

  Need.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    areaId = json['areaId'];
    bidEndTime = json['bidEndTime'];
    bidNum = json['bidNum'];
    bidStartTime = json['bidStartTime'];
    command = json['command'];
    contactName = json['contactName'];
    contactPhone = json['contactPhone'];
    emergency = json['emergency'];
    endTime = json['endTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    needType = json['needType'];
    nurseLevel = json['nurseLevel'];
    nurseRequire = json['nurseRequire'];
    nurseTypeId = json['nurseTypeId'];
    nurseTypeName = json['nurseTypeName'];
    patientDescription = json['patientDescription'];
    patientIdentId = json['patientIdentId'];
    patientName = json['patientName'];
    patientSex = json['patientSex'];
    preferPrice = json['preferPrice'];
    price = json['price'];
    serverTime = json['serverTime'];
    startTime = json['startTime'];
    status = json['status'];
    title = json['title'];
    totalTime = json['totalTime'];
    unit = json['unit'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['areaId'] = this.areaId;
    data['bidEndTime'] = this.bidEndTime;
    data['bidNum'] = this.bidNum;
    data['bidStartTime'] = this.bidStartTime;
    data['command'] = this.command;
    data['contactName'] = this.contactName;
    data['contactPhone'] = this.contactPhone;
    data['emergency'] = this.emergency;
    data['endTime'] = this.endTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['needType'] = this.needType;
    data['nurseLevel'] = this.nurseLevel;
    data['nurseRequire'] = this.nurseRequire;
    data['nurseTypeId'] = this.nurseTypeId;
    data['nurseTypeName'] = this.nurseTypeName;
    data['patientDescription'] = this.patientDescription;
    data['patientIdentId'] = this.patientIdentId;
    data['patientName'] = this.patientName;
    data['patientSex'] = this.patientSex;
    data['preferPrice'] = this.preferPrice;
    data['price'] = this.price;
    data['serverTime'] = this.serverTime;
    data['startTime'] = this.startTime;
    data['status'] = this.status;
    data['title'] = this.title;
    data['totalTime'] = this.totalTime;
    data['unit'] = this.unit;
    data['userId'] = this.userId;
    return data;
  }
}
