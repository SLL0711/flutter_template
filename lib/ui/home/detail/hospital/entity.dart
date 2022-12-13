import 'package:flutter_medical_beauty/ui/home/entity.dart';

class OrgTotalEntity {
  List<OrgEntity> list = <OrgEntity>[];
  int total = 0;

  OrgTotalEntity();

  OrgTotalEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    if (json['list'] != null) {
      json['list'].forEach((v) {
        OrgEntity item = OrgEntity.fromJson(v);
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

class OrgEntity {
  String address = '';
  int caseNum = 0;
  String description = '';
  int doctorNum = 0;
  String icon = '';
  int id = 0;
  int isAuth = 0;
  String name = '';
  String pics = '';
  ProductEntity productList = ProductEntity();
  int productNum = 0;
  double score = 0;
  int subscribeNum = 0;
  String telephone = '';

  OrgEntity();

  OrgEntity.fromJson(Map<String, dynamic> json) {
    address = json['address'] ?? '';
    caseNum = json['caseNum'] ?? 0;
    description = json['description'] ?? '';
    doctorNum = json['doctorNum'] ?? 0;
    icon = json['icon'] ?? '';
    id = json['id'] ?? 0;
    isAuth = json['isAuth'] ?? 0;
    name = json['name'] ?? '';
    pics = json['pics'] ?? '';
    productNum = json['productNum'] ?? 0;
    score = json['score'] ?? 0;
    subscribeNum = json['subscribeNum'] ?? 0;
    telephone = json['telephone'] ?? '';
    if (json['productList'] != null) {
      productList = ProductEntity.fromJson(json['productList']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = this.address;
    data['caseNum'] = this.caseNum;
    data['description'] = this.description;
    data['doctorNum'] = this.doctorNum;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['isAuth'] = this.isAuth;
    data['name'] = this.name;
    data['pics'] = this.pics;
    data['productNum'] = this.productNum;
    data['score'] = this.score;
    data['subscribeNum'] = this.subscribeNum;
    data['telephone'] = this.telephone;
    data['productList'] = productList.toJson();
    return data;
  }
}