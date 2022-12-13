
import 'dart:convert' as convert;

class DetailComboEntity {
  double finalPrice = 0;
  int id = 0;
  int stock = 0;
  double subscribePrice = 0;
  String pic = '';
  String skuCode = '';
  String spData = '';
  double totalPrice = 0;
  List<ComboEntity> spDataList = <ComboEntity>[];

  // 额外属性
  bool isSelected = false;
  bool isRealSelected = false;

  DetailComboEntity();

  DetailComboEntity.fromJson(Map<String, dynamic> json) {
    finalPrice = json['finalPrice'] ?? 0;
    id = json['id'] ?? 0;
    stock = json['stock'] ?? 0;
    subscribePrice = json['subscribePrice'] ?? 0;
    totalPrice = json['totalPrice'] ?? 0;
    pic = json['pic'] ?? '';
    skuCode = json['skuCode'] ?? '';
    spData = json['spData'] ?? '';
    if (json['spData'] != null) {
      List list = convert.jsonDecode(json['spData']);
      list.forEach((v) {
        spDataList.add(ComboEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['finalPrice'] = this.finalPrice;
    data['id'] = this.id;
    data['stock'] = this.stock;
    data['subscribePrice'] = this.subscribePrice;
    data['totalPrice'] = this.totalPrice;
    data['pic'] = this.pic;
    data['skuCode'] = this.skuCode;
    data['spData'] = this.spData;
    return data;
  }
}

class ComboEntity {
  String key = '';
  String value = '';

  // 额外属性
  bool isSelected = false;

  ComboEntity();

  ComboEntity.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? '';
    value = json['value'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class CommentInfoEntity {
  int goodNum = 0;
  int iconNum = 0;
  int poorNum = 0;
  int total = 0;
  CommentInfoScoreEntity productScore = CommentInfoScoreEntity();

  CommentInfoEntity();

  CommentInfoEntity.fromJson(Map<String, dynamic> json) {
    goodNum = json['goodNum'] ?? 0;
    iconNum = json['iconNum'] ?? 0;
    poorNum = json['poorNum'] ?? 0;
    total = json['total'] ?? 0;
    if (json['productScore'] != null) {
      productScore = CommentInfoScoreEntity.fromJson(json['productScore']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['goodNum'] = this.goodNum;
    data['iconNum'] = this.iconNum;
    data['poorNum'] = this.poorNum;
    data['total'] = this.total;
    data['productScore'] = productScore.toJson();
    return data;
  }
}

class CommentInfoScoreEntity {
  int id = 0;
  int productId = 0;
  double envScore = 0;
  double majorScore = 0;
  double resultScore = 0;
  double serveScore = 0;
  double totalScore = 0;

  CommentInfoScoreEntity();

  CommentInfoScoreEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    productId = json['productId'] ?? 0;
    envScore = json['envScore'] ?? 0;
    majorScore = json['majorScore'] ?? 0;
    resultScore = json['resultScore'] ?? 0;
    serveScore = json['serveScore'] ?? 0;
    totalScore = json['totalScore'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['envScore'] = this.envScore;
    data['majorScore'] = this.majorScore;
    data['resultScore'] = this.resultScore;
    data['serveScore'] = this.serveScore;
    data['totalScore'] = this.totalScore;
    return data;
  }
}

class CommentEntity {
  List<CommentItemEntity> list = <CommentItemEntity>[];
  int total = 0;

  CommentEntity();

  CommentEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      CommentItemEntity item = CommentItemEntity.fromJson(v);
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

class CommentItemEntity {
  int id = 0;
  String pics = '';
  String content = '';
  String createTime = '';
  double envScore = 0;
  double majorScore = 0;
  double resultScore = 0;
  double serveScore = 0;
  int totalScore = 0;
  int hasPic = 0;
  String memberIcon = '';
  int memberId = 0;
  String memberNickName = '';
  int orderId = 0;
  int praiseCount = 0;
  int praiseFlag = 0; // 是否有点赞 0否 1是
  int productId = 0;
  int readCount = 0;
  int replayCount = 0;
  String productName = '';

  int isFirst = 0; // 是否是一级回复 0否 1是
  int replayId = 0;
  int superiorMemberId = 0;
  String superiorIcon = '';
  String superiorNickName = '';

  int replyNum = 0;
  List<CommentChildItemEntity> childList = <CommentChildItemEntity>[];
  int currentPage = 1;

  CommentItemEntity();

  CommentItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pics = json['pics'] ?? '';
    content = json['content'] ?? '';
    createTime = json['createTime'] ?? '';
    envScore = json['envScore'] ?? 0;
    majorScore = json['majorScore'] ?? 0;
    resultScore = json['resultScore'] ?? 0;
    serveScore = json['serveScore'] ?? 0;
    totalScore = json['totalScore'] ?? 0;
    hasPic = json['hasPic'] ?? 0;
    memberIcon = json['memberIcon'] ?? '';
    memberId = json['memberId'] ?? 0;
    memberNickName = json['memberNickName'] ?? '';
    orderId = json['orderId'] ?? 0;
    praiseCount = json['praiseCount'] ?? 0;
    praiseFlag = json['praiseFlag'] ?? 0;
    productId = json['productId'] ?? 0;
    readCount = json['readCount'] ?? 0;
    replayCount = json['replayCount'] ?? 0;
    productName = json['productName'] ?? '';
    isFirst = json['isFirst'] ?? 0;
    replayId = json['replayId'] ?? 0;
    superiorMemberId = json['superiorMemberId'] ?? 0;
    superiorIcon = json['superiorIcon'] ?? '';
    superiorNickName = json['superiorNickName'] ?? '';
    replyNum = json['replyNum'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['pics'] = this.pics;
    data['content'] = this.content;
    data['createTime'] = this.createTime;
    data['envScore'] = this.envScore;
    data['majorScore  '] = this.majorScore;
    data['resultScore'] = this.resultScore;
    data['serveScore'] = this.serveScore;
    data['totalScore'] = this.totalScore;
    data['hasPic'] = this.hasPic;
    data['memberIcon'] = this.memberIcon;
    data['memberId'] = this.memberId;
    data['memberNickName'] = this.memberNickName;
    data['orderId'] = this.orderId;
    data['praiseCount'] = this.praiseCount;
    data['praiseFlag'] = this.praiseFlag;
    data['productId'] = this.productId;
    data['readCount'] = this.readCount;
    data['replayCount'] = this.replayCount;
    data['productName'] = this.productName;
    data['isFirst'] = this.isFirst;
    data['replayId'] = this.replayId;
    data['superiorMemberId'] = this.superiorMemberId;
    data['superiorIcon'] = this.superiorIcon;
    data['superiorNickName'] = this.superiorNickName;
    data['replyNum'] = this.replyNum;
    return data;
  }
}

class CommentChildItemEntity {
  int id = 0;
  String pics = '';
  String content = '';
  String createTime = '';
  double envScore = 0;
  double majorScore = 0;
  double resultScore = 0;
  double serveScore = 0;
  int totalScore = 0;
  int hasPic = 0;
  String memberIcon = '';
  int memberId = 0;
  String memberNickName = '';
  int orderId = 0;
  int praiseCount = 0;
  int praiseFlag = 0; // 是否有点赞 0否 1是
  int productId = 0;
  int readCount = 0;
  int replayCount = 0;
  String productName = '';

  int isFirst = 0; // 是否是一级回复 0否 1是
  int replayId = 0;
  int superiorMemberId = 0;
  String superiorIcon = '';
  String superiorNickName = '';
  int replyNum = 0;

  CommentChildItemEntity();

  CommentChildItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pics = json['pics'] ?? '';
    content = json['content'] ?? '';
    createTime = json['createTime'] ?? '';
    envScore = json['envScore'] ?? 0;
    majorScore = json['majorScore'] ?? 0;
    resultScore = json['resultScore'] ?? 0;
    serveScore = json['serveScore'] ?? 0;
    totalScore = json['totalScore'] ?? 0;
    hasPic = json['hasPic'] ?? 0;
    memberIcon = json['memberIcon'] ?? '';
    memberId = json['memberId'] ?? 0;
    memberNickName = json['memberNickName'] ?? '';
    orderId = json['orderId'] ?? 0;
    praiseCount = json['praiseCount'] ?? 0;
    praiseFlag = json['praiseFlag'] ?? 0;
    productId = json['productId'] ?? 0;
    readCount = json['readCount'] ?? 0;
    replayCount = json['replayCount'] ?? 0;
    productName = json['productName'] ?? '';
    isFirst = json['isFirst'] ?? 0;
    replayId = json['replayId'] ?? 0;
    superiorMemberId = json['superiorMemberId'] ?? 0;
    superiorIcon = json['superiorIcon'] ?? '';
    superiorNickName = json['superiorNickName'] ?? '';
    replyNum = json['replyNum'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['pics'] = this.pics;
    data['content'] = this.content;
    data['createTime'] = this.createTime;
    data['envScore'] = this.envScore;
    data['majorScore  '] = this.majorScore;
    data['resultScore'] = this.resultScore;
    data['serveScore'] = this.serveScore;
    data['totalScore'] = this.totalScore;
    data['hasPic'] = this.hasPic;
    data['memberIcon'] = this.memberIcon;
    data['memberId'] = this.memberId;
    data['memberNickName'] = this.memberNickName;
    data['orderId'] = this.orderId;
    data['praiseCount'] = this.praiseCount;
    data['praiseFlag'] = this.praiseFlag;
    data['productId'] = this.productId;
    data['readCount'] = this.readCount;
    data['replayCount'] = this.replayCount;
    data['productName'] = this.productName;
    data['isFirst'] = this.isFirst;
    data['replayId'] = this.replayId;
    data['superiorMemberId'] = this.superiorMemberId;
    data['superiorIcon'] = this.superiorIcon;
    data['superiorNickName'] = this.superiorNickName;
    data['replyNum'] = this.replyNum;
    return data;
  }
}