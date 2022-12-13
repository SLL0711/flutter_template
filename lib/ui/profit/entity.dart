class PosterEntity {
  String imageUrl = '';

  PosterEntity();

  PosterEntity.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

class PosterListEntity {
  List<PosterEntity> list = <PosterEntity>[];

  PosterListEntity.fromJson(Map<String, dynamic> json) {
    json['list'].forEach((v) {
      PosterEntity item = PosterEntity.fromJson(v);
      list.add(item);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['list'] = this.list.map((v) => v).toList();
    return data;
  }
}