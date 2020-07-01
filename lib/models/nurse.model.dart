class Nurse {
  String address;
  String advantageDescription;
  String area;
  String birthday;
  int commend;
  String createTime;
  int deleted;
  String experienceDescription;
  String goodCard;
  int grade;
  String headImg;
  String healthCard;
  String id;
  String identId;
  String identityBack;
  String identityFront;
  String idleTimes;
  String imgNurseCard;
  String nurseLevel;
  String nurseLevelId;
  String nurseNum;
  String nurseType;
  String nurseTypeId;
  String phone;
  int qualificationsCertification;
  String realName;
  int realNameCertification;
  int sex;
  String skillDescription;
  int state;
  String updateTime;
  String userId;
  int workAllTimes;
  String workStartTime;
  int workStatus;
  int workTimes;

  Nurse(
      {this.address,
      this.advantageDescription,
      this.area,
      this.birthday,
      this.commend,
      this.createTime,
      this.deleted,
      this.experienceDescription,
      this.goodCard,
      this.grade,
      this.headImg,
      this.healthCard,
      this.id,
      this.identId,
      this.identityBack,
      this.identityFront,
      this.idleTimes,
      this.imgNurseCard,
      this.nurseLevel,
      this.nurseLevelId,
      this.nurseNum,
      this.nurseType,
      this.nurseTypeId,
      this.phone,
      this.qualificationsCertification,
      this.realName,
      this.realNameCertification,
      this.sex,
      this.skillDescription,
      this.state,
      this.updateTime,
      this.userId,
      this.workAllTimes,
      this.workStartTime,
      this.workStatus,
      this.workTimes});

  Nurse.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    advantageDescription = json['advantageDescription'];
    area = json['area'];
    birthday = json['birthday'];
    commend = json['commend'];
    createTime = json['createTime'];
    deleted = json['deleted'];
    experienceDescription = json['experienceDescription'];
    goodCard = json['goodCard'];
    grade = json['grade'];
    headImg = json['headImg'];
    healthCard = json['healthCard'];
    id = json['id'];
    identId = json['identId'];
    identityBack = json['identityBack'];
    identityFront = json['identityFront'];
    idleTimes = json['idleTimes'];
    imgNurseCard = json['imgNurseCard'];
    nurseLevel = json['nurseLevel'];
    nurseLevelId = json['nurseLevelId'];
    nurseNum = json['nurseNum'];
    nurseType = json['nurseType'];
    nurseTypeId = json['nurseTypeId'];
    phone = json['phone'];
    qualificationsCertification = json['qualificationsCertification'];
    realName = json['realName'];
    realNameCertification = json['realNameCertification'];
    sex = json['sex'];
    skillDescription = json['skillDescription'];
    state = json['state'];
    updateTime = json['updateTime'];
    userId = json['userId'];
    workAllTimes = json['workAllTimes'];
    workStartTime = json['workStartTime'];
    workStatus = json['workStatus'];
    workTimes = json['workTimes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['advantageDescription'] = this.advantageDescription;
    data['area'] = this.area;
    data['birthday'] = this.birthday;
    data['commend'] = this.commend;
    data['createTime'] = this.createTime;
    data['deleted'] = this.deleted;
    data['experienceDescription'] = this.experienceDescription;
    data['goodCard'] = this.goodCard;
    data['grade'] = this.grade;
    data['headImg'] = this.headImg;
    data['healthCard'] = this.healthCard;
    data['id'] = this.id;
    data['identId'] = this.identId;
    data['identityBack'] = this.identityBack;
    data['identityFront'] = this.identityFront;
    data['idleTimes'] = this.idleTimes;
    data['imgNurseCard'] = this.imgNurseCard;
    data['nurseLevel'] = this.nurseLevel;
    data['nurseLevelId'] = this.nurseLevelId;
    data['nurseNum'] = this.nurseNum;
    data['nurseType'] = this.nurseType;
    data['nurseTypeId'] = this.nurseTypeId;
    data['phone'] = this.phone;
    data['qualificationsCertification'] = this.qualificationsCertification;
    data['realName'] = this.realName;
    data['realNameCertification'] = this.realNameCertification;
    data['sex'] = this.sex;
    data['skillDescription'] = this.skillDescription;
    data['state'] = this.state;
    data['updateTime'] = this.updateTime;
    data['userId'] = this.userId;
    data['workAllTimes'] = this.workAllTimes;
    data['workStartTime'] = this.workStartTime;
    data['workStatus'] = this.workStatus;
    data['workTimes'] = this.workTimes;
    return data;
  }
}
