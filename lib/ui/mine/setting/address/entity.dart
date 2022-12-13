class AddressEntity {
  String city = '';
  int defaultStatus = 0;
  int id = 0;
  String detailAddress = '';
  int memberId = 0;
  String name = '';
  String phoneNumber = '';
  String postCode = '';
  String province = '';
  String region = '';

  AddressEntity();

  AddressEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    defaultStatus = json['defaultStatus'] ?? 0;
    memberId = json['memberId'] ?? 0;
    city = json['city'] ?? '';
    detailAddress = json['detailAddress'] ?? '';
    name = json['name'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    postCode = json['postCode'] ?? '';
    province = json['province'] ?? '';
    region = json['region'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['defaultStatus'] = this.defaultStatus;
    data['memberId'] = this.memberId;
    data['city'] = this.city;
    data['defaultStatus'] = this.defaultStatus;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['postCode'] = this.postCode;
    data['province'] = this.province;
    data['region'] = this.region;
    return data;
  }
}