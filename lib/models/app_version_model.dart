class AppVersion {
  String id;
  String createTime;
  String updateTime;
  int deleted;
  String vesionNew;
  String vesionStable;
  String versionNewUrl;
  String versionStableUrl;
  String version;
  String name;
  int appType;

  AppVersion(
      {this.id,
      this.createTime,
      this.updateTime,
      this.deleted,
      this.vesionNew,
      this.vesionStable,
      this.versionNewUrl,
      this.versionStableUrl,
      this.version,
      this.name,
      this.appType});

  AppVersion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deleted = json['deleted'];
    vesionNew = json['vesionNew'];
    vesionStable = json['vesionStable'];
    versionNewUrl = json['versionNewUrl'];
    versionStableUrl = json['versionStableUrl'];
    version = json['version'];
    name = json['name'];
    appType = json['appType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['deleted'] = this.deleted;
    data['vesionNew'] = this.vesionNew;
    data['vesionStable'] = this.vesionStable;
    data['versionNewUrl'] = this.versionNewUrl;
    data['versionStableUrl'] = this.versionStableUrl;
    data['version'] = this.version;
    data['name'] = this.name;
    data['appType'] = this.appType;
    return data;
  }
}
