
class ConsultEntity {
  List<ConsultOrderEntity> list = <ConsultOrderEntity>[];
  int total = 0;

  ConsultEntity();

  ConsultEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      ConsultOrderEntity item = ConsultOrderEntity.fromJson(v);
      list.add(item);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['list'] = this.list.map((v) => v).toList();
    data['total'] = this.total;
    return data;
  }
}

class ConsultOrderEntity {
  String createTime = '';
  int doctorId = 0;
  String doctorName = '';
  int doctorMemberId = 0;
  int id = 0;
  String memberAvatar = '';
  int memberId = 0;
  String memberName = '';
  String orderSn = '';
  String payTime = '';
  int productCategoryIId = 0;
  String productCategoryName = '';
  int sponsorType = 0;
  int status = 0;
  String subscribeBeginTime = '';
  String subscribeEndTime = '';
  int type = 0;

  ConsultOrderEntity();

  ConsultOrderEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'] ?? '';
    doctorId = json['doctorId'] ?? 0;
    doctorName = json['doctorName'] ?? '';
    doctorMemberId = json['doctorMemberId'] ?? 0;
    id = json['id'] ?? 0;
    memberAvatar = json['memberAvatar'] ?? '';
    memberId = json['memberId'] ?? 0;
    memberName = json['memberName'] ?? '';
    orderSn = json['orderSn'] ?? '';
    payTime = json['payTime'] ?? '';
    productCategoryIId = json['productCategoryIId'] ?? 0;
    productCategoryName = json['productCategoryName'] ?? '';
    sponsorType = json['sponsorType'] ?? 0;
    status = json['status'] ?? 0;
    subscribeBeginTime = json['subscribeBeginTime'] ?? '';
    subscribeEndTime = json['subscribeEndTime'] ?? '';
    type = json['type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['doctorId'] = this.doctorId;
    data['doctorName'] = this.doctorName;
    data['doctorMemberId'] = this.doctorMemberId;
    data['id'] = this.id;
    data['memberAvatar'] = this.memberAvatar;
    data['memberId'] = this.memberId;
    data['memberName'] = this.memberName;
    data['orderSn'] = this.orderSn;
    data['payTime'] = this.payTime;
    data['productCategoryIId'] = this.productCategoryIId;
    data['productCategoryName'] = this.productCategoryName;
    data['sponsorType'] = this.sponsorType;
    data['status'] = this.status;
    data['subscribeBeginTime'] = this.subscribeBeginTime;
    data['subscribeEndTime'] = this.subscribeEndTime;
    data['type'] = this.type;
    return data;
  }
}
