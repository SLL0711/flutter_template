class HomeAddressEntity {
  int id = 0;
  int pid = 0;
  int level = 0;
  String name = '';
  String fullname = '';
  String location = '';
  int sheng = 0;
  int shi = 0;
  int xian = 0;

  // 额外属性
  bool isSelected = false;

  HomeAddressEntity();

  HomeAddressEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pid = json['pid'] ?? 0;
    level = json['level'] ?? 0;
    sheng = json['sheng'] ?? 0;
    shi = json['shi'] ?? 0;
    xian = json['xian'] ?? 0;
    name = json['name'] ?? '';
    fullname = json['fullname'] ?? '';
    location = json['location'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['level'] = this.level;
    data['sheng'] = this.sheng;
    data['shi'] = this.shi;
    data['xian'] = this.xian;
    data['name'] = this.name;
    data['fullname'] = this.fullname;
    data['location'] = this.location;
    return data;
  }
}

class HomeDistanceEntity {
  String city = '';

  // 额外属性
  bool isSelected = false;

  HomeDistanceEntity();

  HomeDistanceEntity.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['city'] = this.city;
    return data;
  }
}

class HomeSmartEntity {
  String city = '';

  // 额外属性
  bool isSelected = false;

  HomeSmartEntity.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['city'] = this.city;
    return data;
  }
}

class HomeScreeningEntity {
  String city = '';

  // 额外属性
  bool isSelected = false;

  HomeScreeningEntity.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['city'] = this.city;
    return data;
  }
}

class BannerEntity {
  String pic = '';
  String url = '';

  BannerEntity();

  BannerEntity.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] ?? '';
    url = json['url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['pic'] = this.pic;
    data['url'] = this.url;
    return data;
  }
}

class TabEntity {
  int id = 0;
  String name = '';
  String icon = '';
  List<TabEntity> children = <TabEntity>[];

  bool isSelected = false;

  TabEntity();

  TabEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    icon = json['icon'] ?? '';
    if (json['children'] != null) {
      json['children'].forEach((v) {
        children.add(TabEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['children'] = this.children.map((v) => v).toList();
    return data;
  }
}

class ProductEntity {
  List<ProductItemEntity> list = <ProductItemEntity>[];
  int total = 0;

  ProductEntity();

  ProductEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      ProductItemEntity item = ProductItemEntity.fromJson(v);
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

class ProductItemEntity {
  int id = 0;
  String pic = '';
  String name = '';
  double promotionPrice = 0;
  double minPrice = 0;
  double price = 0;
  int isEnableFee = 0; // 是否可免费体验 0否 1是
  int reserveNum = 0;
  String orgName = '';
  String distance = '';
  int groupMemberNum = 0;
  double groupTotalPrice = 0;

  // 详情
  String albumPics = '';
  List<String> albumPicsList = <String>[];
  int isEnableAging = 0; // 是否可以分期：0否 1是
  int stock = 0;
  int orgId = 0;
  String subTitle = '';
  int sale = 0;

  ProductItemEntity();

  ProductItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    pic = json['pic'] ?? '';
    name = json['name'] ?? '';
    promotionPrice = json['promotionPrice'] ?? 0;
    minPrice = json['minPrice'] ?? 0;
    price = json['price'] ?? 0;
    isEnableFee = json['isEnableFee'] ?? 0;
    reserveNum = json['reserveNum'] ?? 0;
    orgName = json['orgName'] ?? '';
    distance = json['distance'] ?? '';
    groupMemberNum = json['groupMemberNum'] ?? 0;
    groupTotalPrice = json['groupTotalPrice'] ?? 0;
    albumPics = json['albumPics'] ?? '';
    if (albumPics.isNotEmpty) {
      albumPicsList = albumPics.split(',');
    }
    isEnableAging = json['isEnableAging'] ?? 0;
    stock = json['stock'] ?? 0;
    orgId = json['orgId'] ?? 0;
    subTitle = json['subTitle'] ?? '';
    sale = json['sale'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['pic'] = this.pic;
    data['name'] = this.name;
    data['promotionPrice'] = this.promotionPrice;
    data['minPrice'] = this.minPrice;
    data['price'] = this.price;
    data['isEnableFee'] = this.isEnableFee;
    data['reserveNum'] = this.reserveNum;
    data['orgName'] = this.orgName;
    data['distance'] = this.distance;
    data['groupMemberNum'] = this.groupMemberNum;
    data['groupTotalPrice'] = this.groupTotalPrice;
    data['albumPics'] = this.albumPics;
    data['isEnableAging'] = this.isEnableAging;
    data['stock'] = this.stock;
    data['orgId'] = this.orgId;
    data['subTitle'] = this.subTitle;
    data['sale'] = this.sale;
    return data;
  }
}

class ScreeningParams {
  String cityCode = '';
  int cleverSortType = 0; // 智能排序类型 1智能排序 2人气最高 3综合评价 4销量最多 5最新上架 6价格最高 7价格最低
  int distanceFilterType = 0; // 距离筛选类型 1按离我最近 2距离范围
  int groupFlag = 0; // 是否拼团商品 0否 1是
  int maxDistance = 0;
  int minDistance = 0;
  String latitude = '';
  String longitude = '';
  int maxPrice = 0;
  int minPrice = 0;
  int orgId = 0;
  int orgTypeId = 0;
  String provinceCode = '';
  int recommendFlag = 0; // 是否推荐(商品) 0否 1是

  ScreeningParams();
}

class OrganizationEntity {
  int id = 0;
  int isAuth = 0; // 是否认证 0否 1是
  int caseNum = 0;
  int doctorNum = 0;
  int productNum = 0;
  int subscribeNum = 0;
  int typeId = 0;
  double score = 0;
  double latitude = 0;
  double longitude = 0;
  String address = '';
  String cityCode = '';
  String provinceCode = '';
  String createTime = '';
  String description = '';
  String icon = '';
  String name = '';
  String pics = '';
  String telephone = '';

  // 额外属性
  bool isSelected = false;

  OrganizationEntity();

  OrganizationEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    isAuth = json['isAuth'] ?? 0;
    caseNum = json['caseNum'] ?? 0;
    doctorNum = json['doctorNum'] ?? 0;
    productNum = json['productNum'] ?? 0;
    subscribeNum = json['subscribeNum'] ?? 0;
    typeId = json['typeId'] ?? 0;
    score = json['score'] ?? 0;
    latitude = json['latitude'] ?? 0;
    longitude = json['longitude'] ?? 0;
    address = json['address'] ?? '';
    cityCode = json['cityCode'] ?? '';
    provinceCode = json['provinceCode'] ?? '';
    createTime = json['createTime'] ?? '';
    description = json['description'] ?? '';
    icon = json['icon'] ?? '';
    name = json['name'] ?? '';
    pics = json['pics'] ?? '';
    telephone = json['telephone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['isAuth'] = this.isAuth;
    data['caseNum'] = this.caseNum;
    data['doctorNum'] = this.doctorNum;
    data['productNum'] = this.productNum;
    data['subscribeNum'] = this.subscribeNum;
    data['typeId'] = this.typeId;
    data['score'] = this.score;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['cityCode'] = this.cityCode;
    data['provinceCode'] = this.provinceCode;
    data['createTime'] = this.createTime;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['pics'] = this.pics;
    data['telephone'] = this.telephone;
    return data;
  }
}

class OrganizationTypeEntity {
  int id = 0;
  String typeName = '';

  // 额外属性
  bool isSelected = false;

  OrganizationTypeEntity();

  OrganizationTypeEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    typeName = json['typeName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['typeName'] = this.typeName;
    return data;
  }
}

class ProductDetailEntity {
  String name = '';
  int isCollect = 0; // 是否收藏 0否 1是
  int isGroupProduct = 0;
  double groupTotalPrice = 0;
  double minPrice = 0;
  ProductItemEntity product = ProductItemEntity();
  List<AttributeEntity> productAttributeVO = <AttributeEntity>[];
  List<ProjectPricesEntity> productProjectPrices = <ProjectPricesEntity>[];

  ProductDetailEntity();

  ProductDetailEntity.fromJson(Map<String, dynamic> json) {
    isCollect = json['isCollect'] ?? 0;
    name = json['name'] ?? '';
    isGroupProduct = json['isGroupProduct'] ?? 0;
    groupTotalPrice = json['groupTotalPrice'] ?? 0;
    minPrice = json['minPrice'] ?? 0;
    if (json['product'] != null) {
      product = ProductItemEntity.fromJson(json['product']);
    }
    if (json['productAttributeVO'] != null) {
      json['productAttributeVO'].forEach((v) {
        AttributeEntity item = AttributeEntity.fromJson(v);
        productAttributeVO.add(item);
      });
    }
    if (json['productProjectPrices'] != null) {
      json['productProjectPrices'].forEach((v) {
        ProjectPricesEntity item = ProjectPricesEntity.fromJson(v);
        productProjectPrices.add(item);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isCollect'] = this.isCollect;
    data['name'] = this.name;
    data['isGroupProduct'] = this.isGroupProduct;
    data['groupTotalPrice'] = this.groupTotalPrice;
    data['minPrice'] = this.minPrice;
    data['product'] = this.product.toJson();
    data['productAttributeVO'] = this.productAttributeVO.map((v) => v).toList();
    data['productProjectPrices'] =
        this.productProjectPrices.map((v) => v).toList();
    return data;
  }
}

class AttributeEntity {
  int id = 0;
  String name = '';
  List<AttributeValueEntity> productAttributeValueVOS =
      <AttributeValueEntity>[];

  AttributeEntity();

  AttributeEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    if (json['productAttributeValueVOS'] != null) {
      json['productAttributeValueVOS'].forEach((v) {
        AttributeValueEntity item = AttributeValueEntity.fromJson(v);
        productAttributeValueVOS.add(item);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productAttributeValueVOS'] =
        this.productAttributeValueVOS.map((v) => v).toList();
    return data;
  }
}

class AttributeValueEntity {
  int productAttributeId = 0;
  int productAttributeValueId = 0;
  String value = '';

  AttributeValueEntity();

  AttributeValueEntity.fromJson(Map<String, dynamic> json) {
    productAttributeId = json['productAttributeId'] ?? 0;
    productAttributeValueId = json['productAttributeValueId'] ?? 0;
    value = json['value'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['productAttributeId'] = this.productAttributeId;
    data['productAttributeValueId'] = this.productAttributeValueId;
    data['value'] = this.value;
    return data;
  }
}

class ProjectPricesEntity {
  String projectName = '';
  String projectComb = '';
  String doctor = '';
  double price = 0;

  bool isFirst = false;

  ProjectPricesEntity();

  ProjectPricesEntity.fromJson(Map<String, dynamic> json) {
    projectName = json['projectName'] ?? '';
    projectComb = json['projectComb'] ?? '';
    doctor = json['doctor'] ?? '';
    price = json['price'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['projectName'] = this.projectName;
    data['projectComb'] = this.projectComb;
    data['doctor'] = this.doctor;
    data['price'] = this.price;
    return data;
  }
}

class ConfigEntity {
  int isVipSwitch = 0;

  ConfigEntity();

  ConfigEntity.toJson(Map<String, dynamic> json) {
    this.isVipSwitch = json['isVipSwitch'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isVipSwitch'] = this.isVipSwitch;
    return data;
  }
}

class GroupListEntity {
  List<GroupItemEntity> list = <GroupItemEntity>[];
  int total = 0;

  GroupListEntity();

  GroupListEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    json['list'].forEach((v) {
      GroupItemEntity item = GroupItemEntity.fromJson(v);
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

class GroupItemEntity {
  int activityNumber = 0;
  String failureTime = '';
  int groupInfoId = 0;
  int groupProductId = 0;
  int hour = 0;
  int id = 0;
  String memberAvatar = '';
  int memberId = 0;
  String memberNickName = '';
  int memberNum = 0;
  int productId = 0;
  int status = 0;
  String countdownTime = '';

  GroupItemEntity();

  GroupItemEntity.fromJson(Map<String, dynamic> json) {
    this.activityNumber = json['activityNumber'] ?? 0;
    this.failureTime = json['failureTime'] ?? '';
    this.groupInfoId = json['groupInfoId'] ?? 0;
    this.groupProductId = json['groupProductId'] ?? 0;
    this.hour = json['hour'] ?? 0;
    this.id = json['id'] ?? 0;
    this.memberAvatar = json['memberAvatar'] ?? '';
    this.memberId = json['memberId'] ?? 0;
    this.memberNickName = json['memberNickName'] ?? '';
    this.memberNum = json['memberNum'] ?? 0;
    this.productId = json['productId'] ?? 0;
    this.status = json['status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map();
    data['activityNumber'] = this.activityNumber;
    data['failureTime'] = this.failureTime;
    data['groupInfoId'] = this.groupInfoId;
    data['groupProductId'] = this.groupProductId;
    data['hour'] = this.hour;
    data['id'] = this.id;
    data['memberAvatar'] = this.memberAvatar;
    data['memberId'] = this.memberId;
    data['memberNickName'] = this.memberNickName;
    data['memberNum'] = this.memberNum;
    data['productId'] = this.productId;
    data['status'] = this.status;
    return data;
  }
}
