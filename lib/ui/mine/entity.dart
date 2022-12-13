class MineEntity {
  int id = 0;
  int memberLevelId = 0;
  String levelName = '雀斑会员';
  String nickName = '';
  int attentionNumber = 0;
  int numberOfFans = 0;
  dynamic beautyBalance = 0;
  dynamic beautyBean = 0;
  double heatingPowerValue = 0.0;
  int experienceVoucher = 0;
  int coupon = 0;
  int numberOfMyTeam = 0;
  String icon = '';
  int myFriend = 0;
  int recommendAFriend = 0;
  int shareCount = 0;
  String inviteCode = '';
  String vipValidDate = '';
  int doctorId = 0;

  MineEntity();

  MineEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    memberLevelId = json['memberLevelId'] ?? 0;
    levelName = json['levelName'] ?? '雀斑会员';
    nickName = json['nickName'] ?? '';
    attentionNumber = json['attentionNumber'] ?? 0;
    numberOfFans = json['numberOfFans'] ?? 0;
    beautyBalance = json['beautyBalance'] ?? 0.0;
    beautyBean = json['beautyBean'] ?? 0.0;
    heatingPowerValue = json['heatingPowerValue'].toDouble() ?? 0.0;
    experienceVoucher = json['experienceVoucher'] ?? 0;
    coupon = json['coupon'] ?? 0;
    numberOfMyTeam = json['numberOfMyTeam'] ?? 0;
    icon = json['icon'] ?? '';
    myFriend = json['myFriend'] ?? 0;
    recommendAFriend = json['recommendAFriend'] ?? 0;
    shareCount = json['shareCount'] ?? 0;
    inviteCode = json['inviteCode'] ?? '';
    vipValidDate = json['vipValidDate'] ?? '';
    doctorId = json['doctorId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['memberLevelId'] = this.memberLevelId;
    data['levelName'] = this.levelName;
    data['nickName'] = this.nickName;
    data['attentionNumber'] = this.attentionNumber;
    data['numberOfFans'] = this.numberOfFans;
    data['beautyBalance'] = this.beautyBalance;
    data['beautyBean'] = this.beautyBean;
    data['heatingPowerValue'] = this.heatingPowerValue;
    data['experienceVoucher'] = this.experienceVoucher;
    data['coupon'] = this.coupon;
    data['numberOfMyTeam'] = this.numberOfMyTeam;
    data['icon'] = this.icon;
    data['myFriend'] = this.myFriend;
    data['recommendAFriend'] = this.recommendAFriend;
    data['shareCount'] = this.shareCount;
    data['inviteCode'] = this.inviteCode;
    data['vipValidDate'] = this.vipValidDate;
    data['doctorId'] = this.doctorId;
    return data;
  }
}

class InfoEntity {
  int? id;
  int? gender; // 0->未知；1->男；2->女
  String? birthday;
  String? city;
  String? icon;
  String? nickName;
  String? phone;
  String? userName;
  String? realName;
  String? idCardNumber;

  InfoEntity() {
    id = 0;
    gender = 0;
    birthday = '';
    city = '';
    icon = '';
    nickName = '';
    phone = '';
    userName = '';
    realName = '';
    idCardNumber = '';
  }

  InfoEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    gender = json['gender'] ?? 0;
    birthday = json['birthday'] ?? '';
    city = json['city'] ?? '';
    icon = json['icon'] ?? '';
    nickName = json['nickName'] ?? '';
    phone = json['phone'] ?? '';
    userName = json['userName'] ?? '';
    realName = json['realName'] ?? '';
    idCardNumber = json['idCardNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['city'] = this.city;
    data['icon'] = this.icon;
    data['nickName'] = this.nickName;
    data['phone'] = this.phone;
    data['userName'] = this.userName;
    data['realName'] = this.realName;
    data['idCardNumber'] = this.idCardNumber;
    return data;
  }
}

class SexEntity {
  int gender = 0; // 0->未知；1->男；2->女
  String sex = '未知';
  bool isSelected = false;

  SexEntity.fromJson(Map<String, dynamic> json) {
    gender = json['gender'] ?? 0;
    sex = json['sex'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['gender'] = this.gender;
    data['sex'] = this.sex;
    return data;
  }
}

class TeamEntity {
  int cumulativeLowerLevelMembers = 0;
  String icon = '';
  int id = 0;
  int myFriends = 0;
  String nickName = '';
  int recommendAFriend = 0;
  TeamVosEntity vos = TeamVosEntity();

  TeamEntity();

  TeamEntity.fromJson(Map<String, dynamic> json) {
    cumulativeLowerLevelMembers = json['cumulativeLowerLevelMembers'] ?? 0;
    id = json['id'] ?? 0;
    myFriends = json['myFriends'] ?? 0;
    recommendAFriend = json['recommendAFriend'] ?? 0;
    icon = json['icon'] ?? '';
    nickName = json['nickName'] ?? '';
    vos = TeamVosEntity.fromJson(json['vos']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cumulativeLowerLevelMembers'] = this.cumulativeLowerLevelMembers;
    data['id'] = this.id;
    data['myFriends'] = this.myFriends;
    data['recommendAFriend'] = this.recommendAFriend;
    data['icon'] = this.icon;
    data['nickName'] = this.nickName;
    data['vos'] = this.vos.toJson();
    return data;
  }
}

class TeamVosEntity {
  List<TeamItemEntity> list = <TeamItemEntity>[];
  int total = 0;

  TeamVosEntity();

  TeamVosEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      TeamItemEntity item = TeamItemEntity.fromJson(v);
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

class TeamItemEntity {
  String createTime = '';
  String icon = '';
  int id = 0;
  String nickName = '';
  dynamic awardAmount;

  TeamItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    createTime = json['createTime'] ?? '';
    icon = json['icon'] ?? '';
    nickName = json['nickName'] ?? '';
    awardAmount = json['awardAmount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['createTime'] = this.createTime;
    data['icon'] = this.icon;
    data['nickName'] = this.nickName;
    data['awardAmount'] = this.awardAmount;
    return data;
  }
}

class FansEntity {
  List<FansItemEntity> list = <FansItemEntity>[];
  int total = 0;

  FansEntity();

  FansEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      FansItemEntity item = FansItemEntity.fromJson(v);
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

class FansItemEntity {
  String personalizedSignature = '';
  String icon = '';
  int id = 0;
  String nickName = '';
  int status = 0;

  FansItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    status = json['status'] ?? 0;
    personalizedSignature = json['personalizedSignature'] ?? '';
    icon = json['icon'] ?? '';
    nickName = json['nickName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['personalizedSignature'] = this.personalizedSignature;
    data['icon'] = this.icon;
    data['nickName'] = this.nickName;
    data['status'] = this.status;
    return data;
  }
}

class COSSignEntity {
  String baseUrl = '';
  String bucketName = '';
  String regionId = '';
  String sign = '';
  String sessionToken = '';
  String key = '';

  COSSignEntity.fromJson(Map<String, dynamic> json) {
    baseUrl = json['baseUrl'] ?? '';
    bucketName = json['bucketName'] ?? '';
    regionId = json['regionId'] ?? '';
    sign = json['sign'] ?? '';
    sessionToken = json['sessionToken'] ?? '';
    key = json['key'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['baseUrl'] = this.baseUrl;
    data['bucketName'] = this.bucketName;
    data['regionId'] = this.regionId;
    data['sign'] = this.sign;
    data['sessionToken'] = this.sessionToken;
    data['key'] = this.key;
    return data;
  }
}
