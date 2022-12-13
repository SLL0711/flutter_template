import 'package:flutter_medical_beauty/ui/home/entity.dart';

class DoctorEntity {
  int total = 0;
  List<DoctorItemEntity> list = <DoctorItemEntity>[];

  DoctorEntity();

  DoctorEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      DoctorItemEntity item = DoctorItemEntity.fromJson(v);
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

class DoctorTagEntity {
  int doctorId = 0;
  int id = 0;
  int tagId = 0;
  String tagName = '';

  DoctorTagEntity.fromJson(Map<String, dynamic> json) {
    tagName = json['tagName'] ?? '';
    tagId = json['tagId'] ?? 0;
    doctorId = json['doctorId'] ?? 0;
    id = json['id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tagName'] = this.tagName;
    data['tagId'] = this.tagId;
    data['doctorId'] = this.doctorId;
    data['id'] = this.id;
    return data;
  }
}

class DoctorItemEntity {
  String avatar = '';
  int caseNum = 0;
  int commentNum = 0;
  String duties = '';
  int id = 0;
  int isAuth = 0; // 是否认证 0否 1是
  String name = '';
  int orgId = 0;
  String orgName = '';
  int subscribeNum = 0;
  List<DoctorProjectEntity> doctorProjectListVOS = <DoctorProjectEntity>[];

  // 详情
  String description = '';
  List<DoctorProjectEntity> doctorCertificateVOS = <DoctorProjectEntity>[];
  String honorUrl = '';
  int year = 0;
  double score = 0;
  String beGoodAtProjectName = '';
  int beGoodAtProjectCount = 0;
  OrganizationEntity organizationInfo = OrganizationEntity();

  // 咨询
  List<DoctorTagEntity> tagList = <DoctorTagEntity>[];
  int consultNum = 0;
  int consultStatus = 0;
  int consultNumber = 0;
  int waitingTime = 0;
  int isLike = 0;
  int likeNumber = 0;

  DoctorItemEntity();

  DoctorItemEntity.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] ?? '';
    caseNum = json['caseNum'] ?? 0;
    commentNum = json['commentNum'] ?? 0;
    duties = json['duties'] ?? '';
    id = json['id'] ?? 0;
    isAuth = json['isAuth'] ?? 0;
    isLike = json['isLike'] ?? 0;
    likeNumber = json['likeNumber'] ?? 0;
    name = json['name'] ?? '';
    orgId = json['orgId'] ?? 0;
    orgName = json['orgName'] ?? '';
    subscribeNum = json['subscribeNum'] ?? 0;
    if (json['tagList'] != null) {
      json['tagList'].forEach((v) {
        DoctorTagEntity item = DoctorTagEntity.fromJson(v);
        tagList.add(item);
      });
    }
    if (json['doctorProjectListVOS'] != null) {
      json['doctorProjectListVOS'].forEach((v) {
        DoctorProjectEntity item = DoctorProjectEntity.fromJson(v);
        doctorProjectListVOS.add(item);
      });
    }
    description = json['description'] ?? '';
    if (json['doctorCertificateVOS'] != null) {
      json['doctorCertificateVOS'].forEach((v) {
        DoctorProjectEntity item = DoctorProjectEntity.fromJson(v);
        doctorCertificateVOS.add(item);
      });
    }
    honorUrl = json['honorUrl'] ?? '';
    year = json['year'] ?? 0;
    score = json['score'] ?? 0;
    if (json['organizationInfo'] != null) {
      organizationInfo = OrganizationEntity.fromJson(json['organizationInfo']);
    }
    consultNum = json['consultNum'] ?? 0;
    consultStatus = json['consultStatus'] ?? 0;
    isLike = json['isLike'] ?? 0;
    likeNumber = json['likeNumber'] ?? 0;
    consultNumber = json['consultNumber'] ?? 0;
    waitingTime = json['waitingTime'] ?? 0;
    beGoodAtProjectCount = json['beGoodAtProjectCount'] ?? 0;
    beGoodAtProjectName = json['beGoodAtProjectName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['caseNum'] = this.caseNum;
    data['commentNum'] = this.commentNum;
    data['duties'] = this.duties;
    data['id'] = this.id;
    data['isAuth'] = this.isAuth;
    data['isLike'] = this.isLike;
    data['likeNumber'] = this.likeNumber;
    data['name'] = this.name;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['subscribeNum'] = this.subscribeNum;
    data['doctorProjectListVOS'] =
        this.doctorProjectListVOS.map((v) => v).toList();
    data['description'] = this.description;
    data['doctorCertificateVOS'] =
        this.doctorCertificateVOS.map((v) => v).toList();
    data['tagList'] = this.tagList.map((v) => v).toList();
    data['honorUrl'] = this.honorUrl;
    data['year'] = this.year;
    data['score'] = this.score;
    data['organizationInfo'] = this.organizationInfo.toJson();
    data['consultNum'] = this.consultNum;
    data['consultStatus'] = this.consultStatus;
    data['likeNumber'] = this.likeNumber;
    data['isLike'] = this.isLike;
    data['consultNumber'] = this.consultNumber;
    data['waitingTime'] = this.waitingTime;
    data['beGoodAtProjectCount'] = this.beGoodAtProjectCount;
    data['beGoodAtProjectName'] = this.beGoodAtProjectName;
    return data;
  }
}

class DoctorProjectEntity {
  int doctorId = 0;
  int id = 0;
  String name = '';

  String certificateName = '';
  String certificateUrl = '';

  int categoryId = 0;
  int num = 0;

  String categoryName = '';
  int count = 0;

  bool isSelected = false;

  DoctorProjectEntity();

  DoctorProjectEntity.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'] ?? 0;
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    certificateName = json['certificateName'] ?? '';
    certificateUrl = json['certificateUrl'] ?? '';
    categoryId = json['categoryId'] ?? 0;
    num = json['num'] ?? 0;
    categoryName = json['categoryName'] ?? '';
    count = json['count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['certificateName'] = this.certificateName;
    data['certificateUrl'] = this.certificateUrl;
    data['categoryId'] = this.categoryId;
    data['num'] = this.num;
    data['categoryName'] = this.categoryName;
    data['count'] = this.count;
    return data;
  }
}

class DoctorGoodsTopEntity {
  int allNum = 0;
  int productNum = 0;
  int reserveNum = 0;
  DoctorGoodsTopCategoryEntity productCategoryVOS =
      DoctorGoodsTopCategoryEntity();

  DoctorGoodsTopEntity();

  DoctorGoodsTopEntity.fromJson(Map<String, dynamic> json) {
    allNum = json['allNum'] ?? 0;
    productNum = json['productNum'] ?? 0;
    reserveNum = json['reserveNum'] ?? 0;
    if (json['productCategoryVOS'] != null) {
      productCategoryVOS =
          DoctorGoodsTopCategoryEntity.fromJson(json['productCategoryVOS']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['allNum'] = this.allNum;
    data['productNum'] = this.productNum;
    data['reserveNum'] = this.reserveNum;
    data['productCategoryVOS'] = this.productCategoryVOS.toJson();
    return data;
  }
}

class DoctorGoodsTopCategoryEntity {
  int total = 0;
  List<DoctorProjectEntity> list = <DoctorProjectEntity>[];

  DoctorGoodsTopCategoryEntity();

  DoctorGoodsTopCategoryEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    if (json['list'] != null) {
      json['list'].forEach((v) {
        DoctorProjectEntity item = DoctorProjectEntity.fromJson(v);
        list.add(item);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    data['list'] = this.list.map((v) => v).toList();
    return data;
  }
}

class DiaryEntity {
  int total = 0;
  List<DiaryItemEntity> list = <DiaryItemEntity>[];

  DiaryEntity();

  DiaryEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      DiaryItemEntity item = DiaryItemEntity.fromJson(v);
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

class DiaryItemEntity {
  String beforeImages = '';
  String content = '';
  String createTime = '';
  int doctorId = 0;
  String doctorName = '';
  String icon = '';
  int id = 0;
  int memberId = 0;
  String memberNickName = '';
  String operationTime = '';
  int orgId = 0;
  String orgName = '';
  int praiseCount = 0;
  dynamic price = 0;
  String projectName = '';
  int readCount = 0;
  int replayCount = 0;
  int diaryDetailCount = 0;
  int xday = 0;

  DiaryItemEntity();

  DiaryItemEntity.fromJson(Map<String, dynamic> json) {
    beforeImages = json['beforeImages'] ?? '';
    content = json['content'] ?? '';
    createTime = json['createTime'] ?? '';
    doctorId = json['doctorId'] ?? 0;
    doctorName = json['doctorName'] ?? '';
    icon = json['icon'] ?? '';
    id = json['id'] ?? 0;
    memberId = json['memberId'] ?? 0;
    memberNickName = json['memberNickName'] ?? '';
    operationTime = json['operationTime'] ?? '';
    orgId = json['orgId'] ?? 0;
    orgName = json['orgName'] ?? '';
    praiseCount = json['praiseCount'] ?? 0;
    price = json['price'] ?? '0';
    projectName = json['projectName'] ?? '';
    readCount = json['readCount'] ?? 0;
    replayCount = json['replayCount'] ?? 0;
    diaryDetailCount = json['diaryDetailCount'] ?? 0;
    xday = json['xday'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['beforeImages'] = this.beforeImages;
    data['content'] = this.content;
    data['createTime'] = this.createTime;
    data['doctorId'] = this.doctorId;
    data['doctorName'] = this.doctorName;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['memberNickName'] = this.memberNickName;
    data['operationTime'] = this.operationTime;
    data['orgId'] = this.orgId;
    data['orgName'] = this.orgName;
    data['praiseCount'] = this.praiseCount;
    data['price'] = this.price;
    data['projectName'] = this.projectName;
    data['readCount'] = this.readCount;
    data['replayCount'] = this.replayCount;
    data['diaryDetailCount'] = this.diaryDetailCount;
    data['xday'] = this.xday;
    return data;
  }
}

class DiaryDetailEntity {
  int bookId = 0;
  String content = '';
  String createTime = '';
  int diaryDetailCount = 0;
  String doctorName = '';
  int fileType = 0;
  String fileUrl = '';
  List<String> fileUrlList = [];
  int followStatus = 0;
  String icon = '';
  int id = 0;
  int memberId = 0;
  String name = '';
  String nickName = '';
  String orgName = '';
  String pic = '';
  int praiseCount = 0;
  String price = '';
  int productId = 0;
  int readCount = 0;
  int replayCount = 0;
  int reserveNum = 0;

  DiaryDetailEntity();

  DiaryDetailEntity.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'] ?? 0;
    content = json['content'] ?? '';
    createTime = json['createTime'] ?? '';
    diaryDetailCount = json['diaryDetailCount'] ?? 0;
    doctorName = json['doctorName'] ?? '';
    fileType = json['fileType'] ?? 0;
    fileUrl = json['fileUrl'] ?? '';
    if (fileUrl.isNotEmpty) {
      fileUrlList = fileUrl.split(',');
    }
    followStatus = json['followStatus'] ?? 0;
    icon = json['icon'] ?? '';
    id = json['id'] ?? 0;
    memberId = json['memberId'] ?? 0;
    name = json['name'] ?? '';
    nickName = json['nickName'] ?? '';
    orgName = json['orgName'] ?? '';
    pic = json['pic'] ?? '';
    praiseCount = json['praiseCount'] ?? 0;
    price = json['price'] ?? '';
    productId = json['productId'] ?? 0;
    readCount = json['readCount'] ?? 0;
    replayCount = json['replayCount'] ?? 0;
    reserveNum = json['reserveNum'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bookId'] = bookId;
    data['content'] = content;
    data['createTime'] = createTime;
    data['diaryDetailCount'] = diaryDetailCount;
    data['doctorName'] = doctorName;
    data['fileType'] = fileType;
    data['fileUrl'] = fileUrl;
    data['followStatus'] = followStatus;
    data['icon'] = icon;
    data['id'] = id;
    data['memberId'] = memberId;
    data['name'] = name;
    data['nickName'] = nickName;
    data['orgName'] = orgName;
    data['pic'] = pic;
    data['praiseCount'] = praiseCount;
    data['price'] = price;
    data['productId'] = productId;
    data['readCount'] = readCount;
    data['replayCount'] = replayCount;
    data['reserveNum'] = reserveNum;
    return data;
  }
}

class DiaryCommentEntity {
  List<DiaryCommentItemEntity> list = <DiaryCommentItemEntity>[];
  int total = 0;

  DiaryCommentEntity();

  DiaryCommentEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      DiaryCommentItemEntity item = DiaryCommentItemEntity.fromJson(v);
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

class DiaryCommentItemEntity {
  int commentType = 0;
  String content = '';
  String createTime = '';
  List<DiaryCommentItemEntity> diaryCommentVOS = [];
  int fileType = 0;
  String fileUrl = '';
  String icon = '';
  int id = 0;
  String nickName = '';
  int praiseCount = 0;
  int followStatus = 0;
  String replayMemberIcon = '';
  int replayMemberId = 0;
  String replayMemberName = '';

  DiaryCommentItemEntity();

  DiaryCommentItemEntity.fromJson(Map<String, dynamic> json) {
    commentType = json['commentType'] ?? 0;
    content = json['content'] ?? '';
    createTime = json['createTime'] ?? '';
    (json['diaryCommentVOS'] ?? []).forEach((v) {
      diaryCommentVOS.add(DiaryCommentItemEntity.fromJson(v));
    });
    fileType = json['fileType'] ?? 0;
    fileUrl = json['fileUrl'] ?? '';
    icon = json['icon'] ?? '';
    id = json['id'] ?? 0;
    nickName = json['nickName'] ?? '';
    praiseCount = json['praiseCount'] ?? 0;
    followStatus = json['followStatus'] ?? 0;
    replayMemberIcon = json['replayMemberIcon'] ?? '';
    replayMemberId = json['replayMemberId'] ?? 0;
    replayMemberName = json['replayMemberName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['commentType'] = commentType;
    data['content'] = content;
    data['createTime'] = createTime;
    data['diaryCommentVOS'] = diaryCommentVOS.map((v) => v).toList();
    data['fileType'] = fileType;
    data['fileUrl'] = fileUrl;
    data['icon'] = icon;
    data['id'] = id;
    data['nickName'] = nickName;
    data['praiseCount'] = praiseCount;
    data['followStatus'] = followStatus;
    data['replayMemberIcon'] = replayMemberIcon;
    data['replayMemberId'] = replayMemberId;
    data['replayMemberName'] = replayMemberName;
    return data;
  }
}
