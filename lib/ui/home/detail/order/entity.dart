
class DetailOrderEntity {
  dynamic allPayAmount;
  dynamic beautyBalance;
  double compensateAmount = 0;
  double discountPrice = 0;
  double finalPrice = 0;
  double guaranteeAmount = 0;
  int isAllPay = 0;
  int isEnableFee = 0;
  int isMemberFreeTrial = 0;
  int memberId = 0;
  String memberLevelName = '';
  String name = '';
  String pic = '';
  double price = 0;
  int productCategoryIId = 0;
  int productCategoryIiId = 0;
  int productId = 0;
  int productSkuId = 0;
  double selfBuyRate = 0;
  double subscribePrice = 0;
  double totalPrice = 0;

  DetailOrderEntity();

  DetailOrderEntity.fromJson(Map<String, dynamic> json) {
    allPayAmount = json['allPayAmount'] ?? 0;
    beautyBalance = json['beautyBalance'] ?? 0;
    compensateAmount = json['compensateAmount'] ?? 0;
    discountPrice = json['discountPrice'] ?? 0;
    finalPrice = json['finalPrice'] ?? 0;
    guaranteeAmount = json['guaranteeAmount'] ?? 0;
    isAllPay = json['isAllPay'] ?? 0;
    isEnableFee = json['isEnableFee'] ?? 0;
    isMemberFreeTrial = json['isMemberFreeTrial'] ?? 0;
    memberId = json['memberId'] ?? 0;
    memberLevelName = json['memberLevelName'] ?? '';
    name = json['name'] ?? '';
    pic = json['pic'] ?? '';
    price = json['price'] ?? 0;
    productCategoryIId = json['productCategoryIId'] ?? 0;
    productCategoryIiId = json['productCategoryIiId'] ?? 0;
    productId = json['productId'] ?? 0;
    productSkuId = json['productSkuId'] ?? 0;
    selfBuyRate = json['selfBuyRate'] ?? 0;
    subscribePrice = json['subscribePrice'] ?? 0;
    totalPrice = json['totalPrice'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['allPayAmount'] = this.allPayAmount;
    data['beautyBalance'] = this.beautyBalance;
    data['compensateAmount'] = this.compensateAmount;
    data['discountPrice'] = this.discountPrice;
    data['finalPrice'] = this.finalPrice;
    data['guaranteeAmount'] = this.guaranteeAmount;
    data['isAllPay'] = this.isAllPay;
    data['isEnableFee'] = this.isEnableFee;
    data['isMemberFreeTrial'] = this.isMemberFreeTrial;
    data['memberId'] = this.memberId;
    data['memberLevelName'] = this.memberLevelName;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['price'] = this.price;
    data['productCategoryIId'] = this.productCategoryIId;
    data['productCategoryIiId'] = this.productCategoryIiId;
    data['productId'] = this.productId;
    data['productSkuId'] = this.productSkuId;
    data['selfBuyRate'] = this.selfBuyRate;
    data['subscribePrice'] = this.subscribePrice;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}

class OrderInsuranceEntity {
  String name = '';
  String idCard = '';
  String mobile = '';

  OrderInsuranceEntity();
}

class DetailOrderPayEntity {
  int isPay = 1; // 是否需要支付 0否 1是
  int orderId = 0;
  String orderNo = '';
  double payAmount = 0;

  DetailOrderPayEntity();

  DetailOrderPayEntity.fromJson(Map<String, dynamic> json) {
    isPay = json['isPay'] ?? 0;
    orderId = json['orderId'] ?? 0;
    orderNo = json['orderNo'] ?? 0;
    payAmount = json['payAmount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isPay'] = this.isPay;
    data['orderId'] = this.orderId;
    data['orderNo'] = this.orderNo;
    data['payAmount'] = this.payAmount;
    return data;
  }
}

class PayEntity {
  String aliPayRequest = '';
  String outTradeNo = '';
  WechatPayEntity wxPayRequest = WechatPayEntity();
  int payType = 0;

  PayEntity();

  PayEntity.fromJson(Map<String, dynamic> json) {
    aliPayRequest = json['aliPayRequest'] ?? '';
    outTradeNo = json['outTradeNo'] ?? '';
    payType = json['payType'] ?? 0;
    if (json['wxPayRequest'] != null) {
      wxPayRequest = WechatPayEntity.fromJson(json['wxPayRequest']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['aliPayRequest'] = this.aliPayRequest;
    data['outTradeNo'] = this.outTradeNo;
    data['payType'] = this.payType;
    data['wxPayRequest'] = wxPayRequest.toJson();
    return data;
  }
}

class WechatPayEntity {
  String appId = '';
  String partnerId = '';
  String prepayId = '';
  String packageValue = '';
  String nonceStr = '';
  String sign = '';
  String timeStamp = '';

  WechatPayEntity();

  WechatPayEntity.fromJson(Map<String, dynamic> json) {
    appId = json['appId'] ?? '';
    partnerId = json['partnerId'] ?? '';
    prepayId = json['prepayId'] ?? '';
    packageValue = json['packageValue'] ?? '';
    nonceStr = json['nonceStr'] ?? '';
    sign = json['sign'] ?? '';
    timeStamp = json['timeStamp'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['appId'] = this.appId;
    data['partnerId'] = this.partnerId;
    data['prepayId'] = this.prepayId;
    data['packageValue'] = this.packageValue;
    data['nonceStr'] = this.nonceStr;
    data['sign'] = this.sign;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}