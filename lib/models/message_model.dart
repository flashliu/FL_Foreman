class Message {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  String toUser;
  String title;
  String content;
  int type;
  int status;

  Message(
      {this.id,
      this.createTime,
      this.updateTime,
      this.deleted,
      this.toUser,
      this.title,
      this.content,
      this.type,
      this.status});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    toUser = json['toUser'];
    title = json['title'];
    content = json['content'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['toUser'] = this.toUser;
    data['title'] = this.title;
    data['content'] = this.content;
    data['type'] = this.type;
    data['status'] = this.status;
    return data;
  }
}
