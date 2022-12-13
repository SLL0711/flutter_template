class CouponEntity {
  int id = 0;
  String couponName = '';
  double amount = 0;
  String endTime = '';
  double minPoint = 0;
  String note = '';
  String startTime = '';

  CouponEntity();

  CouponEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    amount = json['amount'] ?? 0;
    minPoint = json['minPoint'] ?? 0;
    couponName = json['couponName'] ?? '';
    endTime = json['endTime'] ?? '';
    note = json['note'] ?? '';
    startTime = json['startTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['minPoint'] = this.minPoint;
    data['couponName'] = this.couponName;
    data['endTime'] = this.endTime;
    data['note'] = this.note;
    data['startTime'] = this.startTime;
    return data;
  }
}