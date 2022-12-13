class OrderEntity {
  List<MineOrderEntity> list = <MineOrderEntity>[];
  int total = 0;

  OrderEntity();

  OrderEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      MineOrderEntity item = MineOrderEntity.fromJson(v);
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

class MineOrderEntity {
  dynamic allPayAmount; // 全款金额
  int commentStatus = 0; // 评价状态：0->未评价; 1->已评价
  int diaryStatus = 0; // 写日记状态：0->未写； 1->已写
  int id = 0;
  int isAllPay = 0; // 是否全款支付
  int isFree = 0; // 是否使用免费体验劵 0否 1是
  String orderSn = '';
  int orderType = 0; // 订单类型：0->正常订单；1->拼团订单；2->体验订单
  double payAmount = 0;
  int payFinalStatus = 0; // 支付尾款金额状态：0->未支付; 1->已支付
  String paymentExpirationTime = '';
  int productId = 0;
  String productName = '';
  String productPic = '';
  int refundStatus = 0; // 退款状态：0->未审核; 1->审核通过; 2->审核失败;3->已打款;4->打款失败
  int status =
      0; // 订单状态：0->待付款；1->待使用(根据支付尾款金额状态展示不同的按钮，支付完成展示核销码)；2->已核销；3->已完成；4->已取消；5->无效订单；6->售后中
  double totalAmount = 0;
  String verificationCode = '';
  int isInvoicing = 0;

  // 详情
  String arriveTime = '';
  double couponAmount = 0;
  String createTime = '';
  int doctorId = 0;
  double finalPayAmount = 0;
  double finalPrice = 0;
  double firstTotalAmount = 0;
  double integrationAmount = 0;
  double integrationFirstAmount = 0;
  int memberId = 0;
  String orgAddress = '';
  int orgId = 0;
  String orgName = '';
  String phone = '';
  String telephone = '';
  double totalProductPrice = 0;

  MineOrderEntity();

  MineOrderEntity.fromJson(Map<String, dynamic> json) {
    allPayAmount = json['allPayAmount'] ?? 0.0;
    commentStatus = json['commentStatus'] ?? 0;
    diaryStatus = json['diaryStatus'] ?? 0;
    orderSn = json['orderSn'] ?? '';
    paymentExpirationTime = json['paymentExpirationTime'] ?? '';
    id = json['id'] ?? 0;
    isAllPay = json['isAllPay'] ?? 0;
    isFree = json['isFree'] ?? 0;
    orderType = json['orderType'] ?? 0;
    payAmount = json['payAmount'] ?? 0;
    payFinalStatus = json['payFinalStatus'] ?? 0;
    productId = json['productId'] ?? 0;
    refundStatus = json['refundStatus'] ?? 0;
    status = json['status'] ?? 0;
    productName = json['productName'] ?? '';
    productPic = json['productPic'] ?? '';
    totalAmount = json['totalAmount'] ?? 0;
    verificationCode = json['verificationCode'] ?? '';
    arriveTime = json['arriveTime'] ?? '';
    couponAmount = json['couponAmount'] ?? 0;
    createTime = json['createTime'] ?? '';
    doctorId = json['doctorId'] ?? 0;
    finalPayAmount = json['finalPayAmount'] ?? 0;
    finalPrice = json['finalPrice'] ?? 0;
    firstTotalAmount = json['firstTotalAmount'] ?? 0;
    integrationAmount = json['integrationAmount'] ?? 0;
    integrationFirstAmount = json['integrationFirstAmount'] ?? 0;
    memberId = json['memberId'] ?? 0;
    orgAddress = json['orgAddress'] ?? '';
    orgId = json['orgId'] ?? 0;
    orgName = json['orgName'] ?? '';
    phone = json['phone'] ?? '';
    telephone = json['telephone'] ?? '';
    totalProductPrice = json['totalProductPrice'] ?? 0;
    isInvoicing = json['isInvoicing'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['allPayAmount'] = this.allPayAmount;
    data['commentStatus'] = this.commentStatus;
    data['diaryStatus'] = this.diaryStatus;
    data['id'] = this.id;
    data['isAllPay'] = this.isAllPay;
    data['isFree'] = this.isFree;
    data['orderSn'] = this.orderSn;
    data['orderType'] = this.orderType;
    data['payAmount'] = this.payAmount;
    data['payFinalStatus'] = this.payFinalStatus;
    data['paymentExpirationTime'] = this.paymentExpirationTime;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productPic'] = this.productPic;
    data['refundStatus'] = this.refundStatus;
    data['status'] = this.status;
    data['arriveTime'] = this.arriveTime;
    data['couponAmount'] = this.couponAmount;
    data['createTime'] = this.createTime;
    data['doctorId'] = this.doctorId;
    data['finalPayAmount'] = this.finalPayAmount;
    data['finalPrice'] = this.finalPrice;
    data['firstTotalAmount'] = this.firstTotalAmount;
    data['integrationAmount'] = this.integrationAmount;
    data['integrationFirstAmount'] = this.integrationFirstAmount;
    data['memberId'] = this.memberId;
    data['orgAddress'] = this.orgAddress;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['phone'] = this.phone;
    data['telephone'] = this.telephone;
    data['totalProductPrice'] = this.totalProductPrice;
    data['isInvoicing'] = this.isInvoicing;
    return data;
  }
}

class MineOrderFinalEntity {
  double amount = 0;
  double beautyBalance = 0;
  double couponAmount = 0;
  double discountPrice = 0;
  double finalPayAmount = 0;
  double finalPrice = 0;
  double integrationAmount = 0;
  int isBeautyGold = 0; // 是否使用颜值金 0否 1是
  int isCoupon = 0; // 是否使用优惠券 0否 1是
  int isHaveBeautyGold = 0; // 是否有颜值金 0否 1是
  int isHaveCoupon = 0; // 是否有优惠券 0否 1是
  int memberCouponId = 0;
  int memberLevel = 0;
  String memberLevelName = '';
  double minPoint = 0;
  String name = '';
  int orderId = 0;
  String pic = '';
  int productId = 0;
  int productSkuId = 0;
  double subscribePrice = 0;
  double vipAmount = 0;

  MineOrderFinalEntity();

  MineOrderFinalEntity.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] ?? 0;
    beautyBalance = json['beautyBalance'] ?? 0;
    couponAmount = json['couponAmount'] ?? 0;
    discountPrice = json['discountPrice'] ?? 0;
    finalPayAmount = json['finalPayAmount'] ?? 0;
    finalPrice = json['finalPrice'] ?? 0;
    integrationAmount = json['integrationAmount'] ?? 0;
    isBeautyGold = json['isBeautyGold'] ?? 0;
    isCoupon = json['isCoupon'] ?? 0;
    isHaveBeautyGold = json['isHaveBeautyGold'] ?? 0;
    isHaveCoupon = json['isHaveCoupon'] ?? 0;
    memberCouponId = json['memberCouponId'] ?? 0;
    memberLevel = json['memberLevel'] ?? 0;
    memberLevelName = json['memberLevelName'] ?? '';
    minPoint = json['minPoint'] ?? 0;
    name = json['name'] ?? '';
    pic = json['pic'] ?? '';
    orderId = json['orderId'] ?? 0;
    productId = json['productId'] ?? 0;
    productSkuId = json['productSkuId'] ?? 0;
    subscribePrice = json['subscribePrice'] ?? 0;
    vipAmount = json['vipAmount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amount'] = this.amount;
    data['beautyBalance'] = this.beautyBalance;
    data['couponAmount'] = this.couponAmount;
    data['discountPrice'] = this.discountPrice;
    data['finalPayAmount'] = this.finalPayAmount;
    data['finalPrice'] = this.finalPrice;
    data['integrationAmount'] = this.integrationAmount;
    data['isBeautyGold'] = this.isBeautyGold;
    data['isHaveBeautyGold'] = this.isHaveBeautyGold;
    data['isHaveCoupon'] = this.isHaveCoupon;
    data['memberCouponId'] = this.memberCouponId;
    data['memberLevel'] = this.memberLevel;
    data['memberLevelName'] = this.memberLevelName;
    data['minPoint'] = this.minPoint;
    data['name'] = this.name;
    data['orderId'] = this.orderId;
    data['pic'] = this.pic;
    data['productId'] = this.productId;
    data['finalPayAmount'] = this.finalPayAmount;
    data['finalPrice'] = this.finalPrice;
    data['productSkuId'] = this.productSkuId;
    data['integrationAmount'] = this.integrationAmount;
    data['subscribePrice'] = this.subscribePrice;
    data['vipAmount'] = this.vipAmount;
    return data;
  }
}

class MineOrderCodeEntity {
  int id = 0;
  String orderSn = '';
  int productId = 0;
  String productPic = '';
  String productName = '';
  int status = 0;
  String verificationCode = '';

  MineOrderCodeEntity();

  MineOrderCodeEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    orderSn = json['orderSn'] ?? '';
    productId = json['productId'] ?? 0;
    productPic = json['productPic'] ?? '';
    productName = json['productName'] ?? '';
    status = json['status'] ?? 0;
    verificationCode = json['verificationCode'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['orderSn'] = this.orderSn;
    data['productId'] = this.productId;
    data['productPic'] = this.productPic;
    data['productName'] = this.productName;
    data['status'] = this.status;
    data['verificationCode'] = this.verificationCode;
    return data;
  }
}
