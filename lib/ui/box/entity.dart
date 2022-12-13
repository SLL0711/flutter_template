class ShoppingCartItemEntity {
  String createTime = '';
  int doctorId = 0;
  int id = 0;
  int memberId = 0;
  String name = '';
  String pic = '';
  double price = 0;
  int productCategoryIId = 0;
  int productId = 0;
  int productSkuId = 0;
  double skuTotalPrice = 0;
  bool isSelected = false;

  ShoppingCartItemEntity();

  ShoppingCartItemEntity.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'] ?? '';
    doctorId = json['doctorId'] ?? 0;
    id = json['id'] ?? 0;
    memberId = json['memberId'] ?? 0;
    name = json['name'] ?? '';
    pic = json['pic'] ?? '';
    price = json['price'] ?? 0;
    productCategoryIId = json['productCategoryIId'] ?? 0;
    productId = json['productId'] ?? 0;
    productSkuId = json['productSkuId'] ?? 0;
    skuTotalPrice = json['skuTotalPrice'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['doctorId'] = this.doctorId;
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['price'] = this.price;
    data['productCategoryIId'] = this.productCategoryIId;
    data['productId'] = this.productId;
    data['productSkuId'] = this.productSkuId;
    data['skuTotalPrice'] = this.skuTotalPrice;
    return data;
  }
}

class ShoppingCartEntity {
  List<ShoppingCartItemEntity> list = <ShoppingCartItemEntity>[];
  int total = 0;

  ShoppingCartEntity();

  ShoppingCartEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      ShoppingCartItemEntity item = ShoppingCartItemEntity.fromJson(v);
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

