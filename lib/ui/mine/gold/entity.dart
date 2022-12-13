class GoldEntity {
  double allBalance = 0;
  double expenditure = 0;
  double withdrawBalance = 0;
  double withdrawingBalance = 0;

  GoldEntity();

  GoldEntity.fromJson(Map<String, dynamic> json) {
    allBalance = json['allBalance'] ?? 0;
    expenditure = json['expenditure'] ?? 0;
    withdrawBalance = json['withdrawBalance'] ?? 0;
    withdrawingBalance = json['withdrawingBalance'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['allBalance'] = this.allBalance;
    data['expenditure'] = this.expenditure;
    data['withdrawBalance'] = this.withdrawBalance;
    data['withdrawingBalance'] = this.withdrawingBalance;
    return data;
  }
}

class GoldInfoEntity {
  List<GoldInfoItemEntity> list = <GoldInfoItemEntity>[];
  int total = 0;

  GoldInfoEntity();

  GoldInfoEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    if (json['list'] != null) {
      json['list'].forEach((v) {
        GoldInfoItemEntity item = GoldInfoItemEntity.fromJson(v);
        list.add(item);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['list'] = this.list.map((v) => v).toList();
    data['total'] = this.total;
    return data;
  }
}

class GoldInfoItemEntity {
  double beautyBalance = 0;
  double beginBalance = 0;
  int changeType = 0; // 0->增加；1->减少
  String createTime = '';
  double endBalance = 0;
  String icon = '';
  int id = 0;
  int memberId = 0;
  String nickName = '';
  String remark = '';

  GoldInfoItemEntity();

  GoldInfoItemEntity.fromJson(Map<String, dynamic> json) {
    beautyBalance = json['beautyBalance'] ?? 0;
    beginBalance = json['beginBalance'] ?? 0;
    changeType = json['changeType'] ?? 0;
    createTime = json['createTime'] ?? '';
    endBalance = json['endBalance'] ?? 0;
    icon = json['icon'] ?? '';
    id = json['id'] ?? 0;
    memberId = json['memberId'] ?? 0;
    nickName = json['nickName'] ?? '';
    remark = json['remark'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['beautyBalance'] = this.beautyBalance;
    data['beginBalance'] = this.beginBalance;
    data['changeType'] = this.changeType;
    data['createTime'] = this.createTime;
    data['endBalance'] = this.endBalance;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['nickName'] = this.nickName;
    data['remark'] = this.remark;
    return data;
  }
}
