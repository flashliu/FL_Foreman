class AppVersion {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  String vesionStable;
  String versionStableUrl;
  String updateContent;
  String name;
  int appType;
  bool updateType;

  AppVersion({
    this.id,
    this.createTime,
    this.updateTime,
    this.deleted,
    this.vesionStable,
    this.versionStableUrl,
    this.updateContent,
    this.name,
    this.appType,
    this.updateType,
  });

  AppVersion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    vesionStable = json['vesionStable'];
    versionStableUrl = json['versionStableUrl'];
    updateContent = json['updateContent'];
    name = json['name'];
    appType = json['appType'];
    updateType = json['updateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['vesionStable'] = this.vesionStable;
    data['versionStableUrl'] = this.versionStableUrl;
    data['updateContent'] = this.updateContent;
    data['name'] = this.name;
    data['appType'] = this.appType;
    data['updateType'] = this.updateType;
    return data;
  }
}
