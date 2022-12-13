import 'dart:core';

class NoticeEntity {
  String content = '';
  String createTime = '';
  String icon = '';
  int id = 0;
  int memberId = 0;
  String title = '';
  int type = 0;

  NoticeEntity();

  NoticeEntity.fromJson(Map<String, dynamic> json) {
    this.content = json['content'] ?? '';
    this.createTime = json['createTime'] ?? '';
    this.icon = json['icon'] ?? '';
    this.id = json['id'] ?? 0;
    this.memberId = json['memberId'] ?? 0;
    this.title = json['title'] ?? '';
    this.type = json['type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data['content'] = this.content;
    data['createTime'] = this.createTime;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}

class NoticeListEntity {
  int total = 0;
  List<NoticeEntity> list = <NoticeEntity>[];

  NoticeListEntity();

  NoticeListEntity.fromJson(Map<String, dynamic> json) {
    this.total = json['total'] ?? 0;
    list.clear();
    json['list'].forEach((v) {
      NoticeEntity item = NoticeEntity.fromJson(v);
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
