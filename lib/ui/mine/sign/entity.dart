class SignEntity {
  String createTime = '';
  dynamic beautyBean = 0;
  int signStatus = 0; // 签到状态 0未签到 1已签到
  String timeStr = '';

  SignEntity();

  SignEntity.fromJson(Map<String, dynamic> json) {
    beautyBean = json['beautyBean'] ?? 0;
    signStatus = json['signStatus'] ?? 0;
    timeStr = json['timeStr'] ?? '';
    createTime = json['createTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['beautyBean'] = this.beautyBean;
    data['signStatus'] = this.signStatus;
    data['timeStr'] = this.timeStr;
    data['createTime'] = this.createTime;
    return data;
  }
}