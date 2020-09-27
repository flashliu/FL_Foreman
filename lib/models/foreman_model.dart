import 'package:FL_Foreman/models/nurse_model.dart';

class Foreman {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  int pageSize;
  int pageNum;
  String username;
  String password;
  String address;
  int sex;
  int state;
  double balance;
  String lastLoginTime;
  int loginNum;
  int type;
  int grade;
  String wechatOpenId;
  String avatar;
  String nickname;
  String headImg;
  int share;
  List<Nurse> nurseList;

  Foreman(
      {this.id,
      this.createTime,
      this.updateTime,
      this.deleted,
      this.pageSize,
      this.pageNum,
      this.username,
      this.password,
      this.address,
      this.sex,
      this.state,
      this.balance,
      this.lastLoginTime,
      this.loginNum,
      this.type,
      this.grade,
      this.wechatOpenId,
      this.avatar,
      this.nickname,
      this.headImg,
      this.share,
      this.nurseList});

  Foreman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    pageSize = json['pageSize'];
    pageNum = json['pageNum'];
    username = json['username'];
    password = json['password'];
    address = json['address'];
    sex = json['sex'];
    state = json['state'];
    balance = json['balance'];
    lastLoginTime = json['lastLoginTime'];
    loginNum = json['loginNum'];
    type = json['type'];
    grade = json['grade'];
    wechatOpenId = json['wechatOpenId'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    headImg = json['headImg'];
    share = json['share'];
    if (json['nurseList'] != null) {
      nurseList = new List<Nurse>();
      json['nurseList'].forEach((v) {
        nurseList.add(new Nurse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['pageSize'] = this.pageSize;
    data['pageNum'] = this.pageNum;
    data['username'] = this.username;
    data['password'] = this.password;
    data['address'] = this.address;
    data['sex'] = this.sex;
    data['state'] = this.state;
    data['balance'] = this.balance;
    data['lastLoginTime'] = this.lastLoginTime;
    data['loginNum'] = this.loginNum;
    data['type'] = this.type;
    data['grade'] = this.grade;
    data['wechatOpenId'] = this.wechatOpenId;
    data['avatar'] = this.avatar;
    data['nickname'] = this.nickname;
    data['headImg'] = this.headImg;
    data['share'] = this.share;
    if (this.nurseList != null) {
      data['nurseList'] = this.nurseList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
