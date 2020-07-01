class User {
  String address;
  String birthday;
  String headImg;
  String identId;
  String identityBack;
  String identityFront;
  String phone;
  String realName;
  String sex;
  int state;
  int type;
  String userId;
  String userName;

  User({
    this.address,
    this.birthday,
    this.headImg,
    this.identId,
    this.identityBack,
    this.identityFront,
    this.phone,
    this.realName,
    this.sex,
    this.state,
    this.type,
    this.userId,
    this.userName,
  });

  User.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    birthday = json['birthday'];
    headImg = json['headImg'];
    identId = json['identId'];
    identityBack = json['identityBack'];
    identityFront = json['identityFront'];
    phone = json['phone'];
    realName = json['realName'];
    sex = json['sex'];
    state = json['state'];
    type = json['type'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['birthday'] = this.birthday;
    data['headImg'] = this.headImg;
    data['identId'] = this.identId;
    data['identityBack'] = this.identityBack;
    data['identityFront'] = this.identityFront;
    data['phone'] = this.phone;
    data['realName'] = this.realName;
    data['sex'] = this.sex;
    data['state'] = this.state;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}
