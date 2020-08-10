class Nurse {
  String id;
  String username;
  String realName;
  String sex;
  String headImg;
  String identIdFront;
  String identIdBack;
  String address;
  String phone;
  String advantageDescription;
  int workTimes;
  String nurseLevel;
  String levelId;
  int grade;
  String nurseCard;
  String idleTimes;
  String goodCard;
  int hasNurseCard;
  int hasHealthCard;
  int hasGoodCard;
  String nurseVideo;
  int state;

  Nurse(
      {this.id,
      this.username,
      this.realName,
      this.sex,
      this.headImg,
      this.identIdFront,
      this.identIdBack,
      this.address,
      this.phone,
      this.advantageDescription,
      this.workTimes,
      this.nurseLevel,
      this.levelId,
      this.grade,
      this.nurseCard,
      this.idleTimes,
      this.goodCard,
      this.hasNurseCard,
      this.hasHealthCard,
      this.hasGoodCard,
      this.nurseVideo,
      this.state});

  Nurse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    realName = json['realName'];
    sex = json['sex'];
    headImg = json['headImg'];
    identIdFront = json['identIdFront'];
    identIdBack = json['identIdBack'];
    address = json['address'];
    phone = json['phone'];
    advantageDescription = json['advantageDescription'];
    workTimes = json['workTimes'];
    nurseLevel = json['nurseLevel'];
    levelId = json['levelId'];
    grade = json['grade'];
    nurseCard = json['nurseCard'];
    idleTimes = json['idleTimes'];
    goodCard = json['goodCard'];
    hasNurseCard = json['hasNurseCard'];
    hasHealthCard = json['hasHealthCard'];
    hasGoodCard = json['hasGoodCard'];
    nurseVideo = json['nurseVideo'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['realName'] = this.realName;
    data['sex'] = this.sex;
    data['headImg'] = this.headImg;
    data['identIdFront'] = this.identIdFront;
    data['identIdBack'] = this.identIdBack;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['advantageDescription'] = this.advantageDescription;
    data['workTimes'] = this.workTimes;
    data['nurseLevel'] = this.nurseLevel;
    data['levelId'] = this.levelId;
    data['grade'] = this.grade;
    data['nurseCard'] = this.nurseCard;
    data['idleTimes'] = this.idleTimes;
    data['goodCard'] = this.goodCard;
    data['hasNurseCard'] = this.hasNurseCard;
    data['hasHealthCard'] = this.hasHealthCard;
    data['hasGoodCard'] = this.hasGoodCard;
    data['nurseVideo'] = this.nurseVideo;
    data['state'] = this.state;
    return data;
  }
}
