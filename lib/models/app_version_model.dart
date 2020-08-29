class AppVersion {
  String name;
  String version;
  String changelog;
  int updatedAt;
  String versionShort;
  String build;
  String installUrl;
  String directInstallUrl;
  String updateUrl;
  Binary binary;

  AppVersion(
      {this.name,
      this.version,
      this.changelog,
      this.updatedAt,
      this.versionShort,
      this.build,
      this.installUrl,
      this.directInstallUrl,
      this.updateUrl,
      this.binary});

  AppVersion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
    changelog = json['changelog'];
    updatedAt = json['updated_at'];
    versionShort = json['versionShort'];
    build = json['build'];
    installUrl = json['installUrl'];
    directInstallUrl = json['direct_install_url'];
    updateUrl = json['update_url'];
    binary = json['binary'] != null ? new Binary.fromJson(json['binary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['version'] = this.version;
    data['changelog'] = this.changelog;
    data['updated_at'] = this.updatedAt;
    data['versionShort'] = this.versionShort;
    data['build'] = this.build;
    data['installUrl'] = this.installUrl;
    data['direct_install_url'] = this.directInstallUrl;
    data['update_url'] = this.updateUrl;
    if (this.binary != null) {
      data['binary'] = this.binary.toJson();
    }
    return data;
  }
}

class Binary {
  int fsize;

  Binary({this.fsize});

  Binary.fromJson(Map<String, dynamic> json) {
    fsize = json['fsize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fsize'] = this.fsize;
    return data;
  }
}
