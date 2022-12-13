class LoginEntity {
  String tokenHead = '';
  String token = '';
  String phone = '';

  LoginEntity.fromJson(Map<String, dynamic> json) {
    tokenHead = json['tokenHead'] ?? '';
    token = json['token'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tokenHead'] = this.tokenHead;
    data['token'] = this.token;
    data['phone'] = this.phone;
    return data;
  }
}

class ArticleEntity {
  String articleCode = '';
  String content = '';
  String title = '';

  ArticleEntity();

  ArticleEntity.fromJson(Map<String, dynamic> json) {
    articleCode = json['articleCode'] ?? '';
    content = json['content'] ?? '';
    title = json['title'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['articleCode'] = this.articleCode;
    data['content'] = this.content;
    data['title'] = this.title;
    return data;
  }
}
