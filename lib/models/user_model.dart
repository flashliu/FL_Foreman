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
  String username;
  String password;
  String phone;
  int state;
  double balance;
  String lastLoginTime;
  int loginNum;
  int type;
  int grade;
  bool enabled;
  bool credentialsNonExpired;
  bool accountNonLocked;
  bool accountNonExpired;

  LoginUser(
      {this.id,
      this.createTime,
      this.updateTime,
      this.deleted,
      this.username,
      this.password,
      this.phone,
      this.state,
      this.balance,
      this.lastLoginTime,
      this.loginNum,
      this.type,
      this.grade,
      this.enabled,
      this.credentialsNonExpired,
      this.accountNonLocked,
      this.accountNonExpired});

  LoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'].toString();
    updateTime = json['updateTime'].toString();
    deleted = json['deleted'];
    username = json['username'];
    password = json['password'];
    phone = json['phone'];
    state = json['state'];
    balance = json['balance'];
    lastLoginTime = json['lastLoginTime'].toString();
    loginNum = json['loginNum'];
    type = json['type'];
    grade = json['grade'];
    enabled = json['enabled'];
    credentialsNonExpired = json['credentialsNonExpired'];
    accountNonLocked = json['accountNonLocked'];
    accountNonExpired = json['accountNonExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['username'] = this.username;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['balance'] = this.balance;
    data['lastLoginTime'] = this.lastLoginTime;
    data['loginNum'] = this.loginNum;
    data['type'] = this.type;
    data['grade'] = this.grade;
    data['enabled'] = this.enabled;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;
    data['accountNonExpired'] = this.accountNonExpired;
    return data;
  }
}
