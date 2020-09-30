class RefundInfo {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  int pageSize;
  int pageNum;
  String userId;
  String orderNo;
  String refundDays;
  double refundAmout;
  String refundPlatform;
  String refundNote;
  int refundStatus;
  int type;
  double orderAmout;
  String username;
  String nickname;
  String refundphone;

  RefundInfo({
    this.id,
    this.createTime,
    this.updateTime,
    this.deleted,
    this.pageSize,
    this.pageNum,
    this.userId,
    this.orderNo,
    this.refundDays,
    this.refundAmout,
    this.refundPlatform,
    this.refundNote,
    this.refundStatus,
    this.type,
    this.orderAmout,
    this.username,
    this.nickname,
    this.refundphone,
  });

  RefundInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    pageSize = json['pageSize'];
    pageNum = json['pageNum'];
    userId = json['userId'];
    orderNo = json['orderNo'];
    refundDays = json['refundDays'];
    refundAmout = json['refundAmout'];
    refundPlatform = json['refundPlatform'];
    refundNote = json['refundNote'];
    refundStatus = json['refundStatus'];
    type = json['type'];
    orderAmout = json['orderAmout'];
    username = json['username'];
    nickname = json['nickname'];
    refundphone = json['refundphone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['pageSize'] = this.pageSize;
    data['pageNum'] = this.pageNum;
    data['userId'] = this.userId;
    data['orderNo'] = this.orderNo;
    data['refundDays'] = this.refundDays;
    data['refundAmout'] = this.refundAmout;
    data['refundPlatform'] = this.refundPlatform;
    data['refundNote'] = this.refundNote;
    data['refundStatus'] = this.refundStatus;
    data['type'] = this.type;
    data['orderAmout'] = this.orderAmout;
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    data['refundphone'] = this.refundphone;
    return data;
  }
}
