import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static String _tokenKey = 'kTokenKey';
  static String _imTokenKey = 'kIMTokenKey';
  static String _key = 'kLoginUser';
  static UserManager? _instance;

  UserManager._();

  static UserManager? shared() {
    if (_instance == null) {
      _instance = UserManager._();
    }
    return _instance;
  }

  /// token
  static Future<String> readToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_tokenKey) ?? '';
    return token;
  }

  void saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
  }

  /// IMToken
  static Future<String> readIMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(_imTokenKey) ?? '';
    return token;
  }

  void saveIMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_imTokenKey, token);
  }

  /// user
  void saveUser(User user) async {
    Map<String, dynamic> tempUser = user.toJson();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, json.encode(tempUser));
  }

  static Future<User> readUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonStr = prefs.getString(_key) ?? '';
    return _userFromJson(jsonStr);
  }

  static User _userFromJson(String jsonStr) {
    User? user;
    if (jsonStr.isNotEmpty) {
      Map<String, dynamic> userJson = json.decode('$jsonStr');
      user = User.fromJson(userJson);
    }
    return user ?? User();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
    prefs.remove(_tokenKey);
  }

  static Future<bool> isLogin() async {
    String token = await readToken();
    if (token.isEmpty) return false;
    return true;
  }
}

class User {
  String? id;
  String? userName;
  String? nickName;
  String? phone;

  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    userName = json['userName'] ?? '';
    nickName = json['nickName'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['nickName'] = this.nickName;
    data['phone'] = this.phone;
    return data;
  }
}
