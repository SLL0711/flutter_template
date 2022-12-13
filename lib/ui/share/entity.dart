class InterestEntity {
  String icon = '';
  String name = '';

  InterestEntity(String name, String icon) {
    this.name = name;
    this.icon = icon;
  }

  InterestEntity.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] ?? '';
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['icon'] = this.icon;
    data['name'] = this.name;
    return data;
  }
}

class ShareConfigEntity {
  double changeMixValue = 0.0;
  double beautyBalance = 0.0;

  ShareConfigEntity();

  ShareConfigEntity.fromJson(Map<String, dynamic> json) {
    changeMixValue = json['changeMixValue'] ?? 0.0;
    beautyBalance = json['beautyBalance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['changeMixValue'] = this.changeMixValue;
    data['beautyBalance'] = this.beautyBalance;
    return data;
  }
}
