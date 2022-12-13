class VersionEntity {
  String versionNumber = '';
  int id = 0;
  int type = 0;
  String versionTitle = '';

  VersionEntity();

  VersionEntity.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? 0;
    id = json['id'] ?? 0;
    versionNumber = json['versionNumber'] ?? '';
    versionTitle = json['versionTitle'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['versionNumber'] = this.versionNumber;
    data['versionTitle'] = this.versionTitle;
    return data;
  }
}