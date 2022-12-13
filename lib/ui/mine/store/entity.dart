class ApplyInfoEntity {
  String address = '';
  int applyType = 0;
  String areaCode = '';
  int auditStatus = 0;
  String auditRemark = '';
  String cityCode = '';
  int id = 0;
  double merchantGuaranteeAmount = 0.0;
  double merchantPayAmount = 0.0;
  int payStatus = 0;
  String provinceCode = '';
  String shopDescription = '';
  String shopLogo = '';
  String shopName = '';
  String tagIds = '';
  ApplyPersonEntity shopApplyMember = ApplyPersonEntity();
  ApplyCompanyEntity shopApplyCompany = ApplyCompanyEntity();

  ApplyInfoEntity();

  ApplyInfoEntity.fromJson(Map<String, dynamic> json) {
    address = json['address'] ?? '';
    applyType = json['applyType'] ?? 0;
    areaCode = json['areaCode'] ?? '';
    auditStatus = json['auditStatus'] ?? 0;
    auditRemark = json['auditRemark'] ?? '';
    cityCode = json['cityCode'] ?? '';
    id = json['id'] ?? 0;
    merchantGuaranteeAmount = json['merchantGuaranteeAmount'] ?? 0.0;
    merchantPayAmount = json['merchantPayAmount'] ?? 0.0;
    payStatus = json['payStatus'] ?? 0;
    provinceCode = json['provinceCode'] ?? '';
    shopDescription = json['shopDescription'] ?? '';
    shopLogo = json['shopLogo'] ?? '';
    shopName = json['shopName'] ?? '';
    tagIds = json['tagIds'] ?? '';
    shopApplyMember =
        ApplyPersonEntity.fromJson(json['shopApplyMember'] ?? Map());
    shopApplyCompany =
        ApplyCompanyEntity.fromJson(json['shopApplyCompany'] ?? Map());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['address'] = this.address;
    data['applyType'] = this.applyType;
    data['areaCode'] = this.areaCode;
    data['auditStatus'] = this.auditStatus;
    data['auditRemark'] = this.auditRemark;
    data['cityCode'] = this.cityCode;
    data['id'] = this.id;
    data['merchantGuaranteeAmount'] = this.merchantGuaranteeAmount;
    data['merchantPayAmount'] = this.merchantPayAmount;
    data['payStatus'] = this.payStatus;
    data['provinceCode'] = this.provinceCode;
    data['shopDescription'] = this.shopDescription;
    data['shopLogo'] = this.shopLogo;
    data['shopName'] = this.shopName;
    data['tagIds'] = this.tagIds;
    data['shopApplyMember'] = this.shopApplyMember.toJson();
    data['shopApplyCompany'] = this.shopApplyCompany.toJson();
    return data;
  }
}

class ApplyPersonEntity {
  String alipayAccount = '';
  int applyId = 0;
  int gender = 1;
  String hairdressingQualificationUrl = '';
  int id = 0;
  String idCardBackImageUrl = '';
  String idCardFrontImageUrl = '';
  String idCardNumber = '';
  String phone = '';
  String practiceUrl = '';
  String qualificationUrl = '';
  String realName = '';
  String wechatAccount = '';

  ApplyPersonEntity();

  ApplyPersonEntity.fromJson(Map<String, dynamic> json) {
    alipayAccount = json['alipayAccount'] ?? '';
    applyId = json['applyId'] ?? 0;
    gender = json['gender'] ?? 1;
    hairdressingQualificationUrl = json['hairdressingQualificationUrl'] ?? '';
    id = json['id'] ?? 0;
    idCardBackImageUrl = json['idCardBackImageUrl'] ?? '';
    idCardFrontImageUrl = json['idCardFrontImageUrl'] ?? '';
    idCardNumber = json['idCardNumber'] ?? '';
    phone = json['phone'] ?? '';
    practiceUrl = json['practiceUrl'] ?? '';
    qualificationUrl = json['qualificationUrl'] ?? '';
    realName = json['realName'] ?? '';
    wechatAccount = json['wechatAccount'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['alipayAccount'] = this.alipayAccount;
    data['applyId'] = this.applyId;
    data['gender'] = this.gender;
    data['hairdressingQualificationUrl'] = this.hairdressingQualificationUrl;
    data['id'] = this.id;
    data['idCardBackImageUrl'] = this.idCardBackImageUrl;
    data['idCardFrontImageUrl'] = this.idCardFrontImageUrl;
    data['idCardNumber'] = this.idCardNumber;
    data['phone'] = this.phone;
    data['practiceUrl'] = this.practiceUrl;
    data['qualificationUrl'] = this.qualificationUrl;
    data['realName'] = this.realName;
    data['wechatAccount'] = this.wechatAccount;
    return data;
  }
}

class ApplyCompanyEntity {
  String account = '';
  String accountName = '';
  String address = '';
  String alipayAccount = '';
  int applyId = 0;
  String areaCode = '';
  String bankName = '';
  String brandAuthImageUrl = '';
  String businessLicenseUrl = '';
  String cityCode = '';
  String companyName = '';
  int id = 0;
  String organizationName = '';
  String phone = '';
  String practiceLicenceUrl = '';
  String provinceCode = '';
  String servicePhone = '';
  String tradeMarkImageUrl = '';
  String wechatAccount = '';

  ApplyCompanyEntity();

  ApplyCompanyEntity.fromJson(Map<String, dynamic> json) {
    account = json['account'] ?? '';
    accountName = json['accountName'] ?? '';
    address = json['address'] ?? '';
    alipayAccount = json['alipayAccount'] ?? '';
    applyId = json['applyId'] ?? 0;
    areaCode = json['areaCode'] ?? '';
    bankName = json['bankName'] ?? '';
    brandAuthImageUrl = json['brandAuthImageUrl'] ?? '';
    businessLicenseUrl = json['businessLicenseUrl'] ?? '';
    cityCode = json['cityCode'] ?? '';
    companyName = json['companyName'] ?? '';
    id = json['id'] ?? 0;
    organizationName = json['organizationName'] ?? '';
    phone = json['phone'] ?? '';
    practiceLicenceUrl = json['practiceLicenceUrl'] ?? '';
    provinceCode = json['provinceCode'] ?? '';
    servicePhone = json['servicePhone'] ?? '';
    tradeMarkImageUrl = json['tradeMarkImageUrl'] ?? '';
    wechatAccount = json['wechatAccount'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['account'] = this.account;
    data['accountName'] = this.accountName;
    data['address'] = this.address;
    data['alipayAccount'] = this.alipayAccount;
    data['applyId'] = this.applyId;
    data['areaCode'] = this.areaCode;
    data['bankName'] = this.bankName;
    data['brandAuthImageUrl'] = this.brandAuthImageUrl;
    data['businessLicenseUrl'] = this.businessLicenseUrl;
    data['cityCode'] = this.cityCode;
    data['companyName'] = this.companyName;
    data['id'] = this.id;
    data['organizationName'] = this.organizationName;
    data['phone'] = this.phone;
    data['practiceLicenceUrl'] = this.practiceLicenceUrl;
    data['provinceCode'] = this.provinceCode;
    data['servicePhone'] = this.servicePhone;
    data['tradeMarkImageUrl'] = this.tradeMarkImageUrl;
    data['wechatAccount'] = this.wechatAccount;
    return data;
  }
}

class TagEntity {
  int id = 0;
  String tagName = '';

  TagEntity();

  TagEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    tagName = json['tagName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map();
    data['id'] = this.id;
    data['tagName'] = this.tagName;
    return data;
  }
}
