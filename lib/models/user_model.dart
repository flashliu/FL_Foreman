class User {
  String accessToken;
  String tokenType;
  String refreshToken;
  int expiresIn;
  String scope;
  LoginUser loginUser;

  User({this.accessToken, this.tokenType, this.refreshToken, this.expiresIn, this.scope, this.loginUser});

  User.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    scope = json['scope'];
    loginUser = json['loginUser'] != null ? new LoginUser.fromJson(json['loginUser']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['expires_in'] = this.expiresIn;
    data['scope'] = this.scope;
    if (this.loginUser != null) {
      data['loginUser'] = this.loginUser.toJson();
    }
    return data;
  }
}

class LoginUser {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  int pageSize;
  int pageNum;
  String username;
  String password;
  String phone;
  int state;
  double balance;
  String lastLoginTime;
  int loginNum;
  int type;
  int grade;
  String nickname;
  int share;
  List<SysRoles> sysRoles;
  List<String> permissions;
  bool enabled;
  bool accountNonExpired;
  bool credentialsNonExpired;
  bool accountNonLocked;
  String headImg;

  LoginUser({
    this.id,
    this.createTime,
    this.updateTime,
    this.deleted,
    this.pageSize,
    this.pageNum,
    this.username,
    this.password,
    this.phone,
    this.state,
    this.balance,
    this.lastLoginTime,
    this.loginNum,
    this.type,
    this.grade,
    this.nickname,
    this.share,
    this.sysRoles,
    this.permissions,
    this.enabled,
    this.accountNonExpired,
    this.credentialsNonExpired,
    this.accountNonLocked,
    this.headImg,
  });

  LoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'].toString();
    updateTime = json['updateTime'].toString();
    deleted = json['deleted'];
    pageSize = json['pageSize'];
    pageNum = json['pageNum'];
    username = json['username'];
    password = json['password'];
    phone = json['phone'];
    state = json['state'];
    balance = json['balance'];
    lastLoginTime = json['lastLoginTime'].toString();
    loginNum = json['loginNum'];
    type = json['type'];
    grade = json['grade'];
    nickname = json['nickname'];
    share = json['share'];
    if (json['sysRoles'] != null && json['sysRoles'].length > 0) {
      sysRoles = new List<SysRoles>();
      json['sysRoles'].forEach((v) {
        sysRoles.add(new SysRoles.fromJson(v));
      });
    }
    permissions = (json['permissions'] ?? []).cast<String>();
    enabled = json['enabled'];
    accountNonExpired = json['accountNonExpired'];
    credentialsNonExpired = json['credentialsNonExpired'];
    accountNonLocked = json['accountNonLocked'];
    headImg = json['headImg'];
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
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['balance'] = this.balance;
    data['lastLoginTime'] = this.lastLoginTime;
    data['loginNum'] = this.loginNum;
    data['type'] = this.type;
    data['grade'] = this.grade;
    data['nickname'] = this.nickname;
    data['share'] = this.share;
    if (this.sysRoles != null) {
      data['sysRoles'] = this.sysRoles.map((v) => v.toJson()).toList();
    }
    data['permissions'] = this.permissions;
    data['enabled'] = this.enabled;
    data['accountNonExpired'] = this.accountNonExpired;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;
    data['headImg'] = this.headImg;
    return data;
  }
}

class SysRoles {
  String id;
  String code;
  String name;
  int createTime;
  int updateTime;

  SysRoles({this.id, this.code, this.name, this.createTime, this.updateTime});

  SysRoles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}
