class OpenMemberEntity {
  int sourceId = 0;
  double payPrice = 0;

  OpenMemberEntity();

  OpenMemberEntity.fromJson(Map<String, dynamic> json) {
    sourceId = json['sourceId'] ?? 0;
    payPrice = json['payPrice'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sourceId'] = this.sourceId;
    data['payPrice'] = this.payPrice;
    return data;
  }
}

class MemberEntity {
  int id = 0;
  int sort = 0;
  String name = '';
  int inviteNum = 0;
  int teamNum = 0;
  String memberEquity = '';
  dynamic inviteCommissionI;
  dynamic inviteCommissionIi;
  dynamic productCommissionI;
  dynamic productCommissionIi;
  dynamic selfBuyRate;

  MemberEntity();

  MemberEntity.fromJson(Map<String, dynamic> json) {
    this.id = json['id'] ?? 0;
    this.sort = json['sort'] ?? 0;
    this.name = json['name'] ?? '';
    this.memberEquity = json['memberEquity'] ?? '';
    this.inviteNum = json['inviteNum'] ?? 0;
    this.teamNum = json['teamNum'] ?? 0;
    this.inviteCommissionI = json['inviteCommissionI'] ?? 0;
    this.inviteCommissionIi = json['inviteCommissionIi'] ?? 0;
    this.productCommissionI = json['productCommissionI'] ?? 0;
    this.productCommissionIi = json['productCommissionIi'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['sort'] = this.sort;
    data['name'] = this.name;
    data['memberEquity'] = this.memberEquity;
    data['inviteNum'] = this.inviteNum;
    data['teamNum'] = this.teamNum;
    data['inviteCommissionI'] = this.inviteCommissionI;
    data['inviteCommissionIi'] = this.inviteCommissionIi;
    data['productCommissionI'] = this.productCommissionI;
    data['productCommissionIi'] = this.productCommissionIi;
    return data;
  }
}
