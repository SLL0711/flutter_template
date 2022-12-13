class InvoiceEntity {
  String code = '';
  String companyName = '';
  String createTime = '';
  String email = '';
  int id = 0;
  int memberId = 0;
  String memberNickName = '';
  String mobile = '';
  int type = 0;

  InvoiceEntity();

  InvoiceEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    companyName = json['companyName'] ?? '';
    createTime = json['createTime'] ?? '';
    email = json['email'] ?? '';
    id = json['id'] ?? 0;
    memberId = json['memberId'] ?? 0;
    memberNickName = json['memberNickName'] ?? '';
    mobile = json['mobile'] ?? '';
    type = json['type'] ?? 0;
  }
}