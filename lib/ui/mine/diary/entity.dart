class DiaryBooksEntity {
  String beforeImages = '';
  int diaryDetailCount = 0;
  String doctorName = '';
  String icon = '';
  int id = 0;
  String name = '';
  String nickName = '';
  String operationTime = '';
  int orderId = 0;
  String orgName = '';
  String price = '';
  int productId = 0;
  String productPic = '';
  List<DiaryBooksItemEntity> vos = <DiaryBooksItemEntity>[];

  DiaryBooksEntity();

  DiaryBooksEntity.fromJson(Map<String, dynamic> json) {
    beforeImages = json['beforeImages'] ?? '';
    diaryDetailCount = json['diaryDetailCount'] ?? 0;
    doctorName = json['doctorName'] ?? '';
    icon = json['icon'] ?? '';
    id = json['id'] ?? 0;
    name = json['name'] ?? 0;
    nickName = json['nickName'] ?? '';
    operationTime = json['operationTime'] ?? '';
    orderId = json['orderId'] ?? 0;
    orgName = json['orgName'] ?? '';
    price = json['price'] ?? '';
    productId = json['productId'] ?? 0;
    productPic = json['productPic'] ?? '';
    if (json['vos'] != null) {
      json['vos'].forEach((element) {
        vos.add(DiaryBooksItemEntity.fromJson(element));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['beforeImages'] = this.beforeImages;
    data['diaryDetailCount'] = this.diaryDetailCount;
    data['doctorName'] = this.doctorName;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['nickName'] = this.nickName;
    data['operationTime'] = this.operationTime;
    data['orderId'] = this.orderId;
    data['orgName'] = this.orgName;
    data['price'] = this.price;
    data['productId'] = this.productId;
    data['productPic'] = this.productPic;
    data['vos'] = this.vos.map((e) => e.toJson());
    return data;
  }
}

class DiaryBooksItemEntity {
  String content = '';
  String createTime = '';
  int dayNum = 0;
  int fileType = 0; // 文件类型 0图片 1视频
  String fileUrl = '';
  int id = 0;
  int praiseCount = 0;
  String projectName = '';
  int readCount = 0;
  int replayCount = 0;

  DiaryBooksItemEntity();

  DiaryBooksItemEntity.fromJson(Map<String, dynamic> json) {
    content = json['content'] ?? '';
    createTime = json['createTime'] ?? '';
    dayNum = json['dayNum'] ?? 0;
    fileType = json['fileType'] ?? 0;
    fileUrl = json['fileUrl'] ?? '';
    id = json['id'] ?? 0;
    praiseCount = json['praiseCount'] ?? 0;
    projectName = json['projectName'] ?? '';
    readCount = json['readCount'] ?? 0;
    replayCount = json['replayCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['content'] = this.content;
    data['createTime'] = this.createTime;
    data['dayNum'] = this.dayNum;
    data['fileType'] = this.fileType;
    data['fileUrl'] = this.fileUrl;
    data['id'] = this.id;
    data['praiseCount'] = this.praiseCount;
    data['projectName'] = this.projectName;
    data['readCount'] = this.readCount;
    data['replayCount'] = this.replayCount;
    return data;
  }
}