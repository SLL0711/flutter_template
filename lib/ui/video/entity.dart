class ConsultOrderEntity {
  int id = 0;
  int memberId = 0;
  String orderSn = '';
  int productCategoryIId = 0;

  ConsultOrderEntity();

  ConsultOrderEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    memberId = json['memberId'] ?? 0;
    orderSn = json['orderSn'] ?? '';
    productCategoryIId = json['productCategoryIId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map();
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['orderSn'] = this.orderSn;
    data['productCategoryIId'] = this.productCategoryIId;
    return data;
  }
}
