import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/login/login.dart';

import 'api.dart';
import 'dart:convert' as convert;

import 'user.dart';

enum Method { get, post, put, delete }

class HttpItem {
  dynamic data;
  String? message;
  int? code;

  HttpItem();

  factory HttpItem.fromJson(Map<String, dynamic> json) {
    HttpItem item = HttpItem();
    item.data = json['data'] ?? {};
    item.message = json['message'] ?? '';
    item.code = json['code'] ?? 0;
    return item;
  }
}

class HttpManager {
  /// 请求
  static Future<HttpItem> sendRequest(String url, Method method,
      BuildContext context, Map<String, dynamic> params) async {
    try {
      Response response;
      Dio dio = Dio();
      // 请求基地址
      dio.options.baseUrl = DsApi.server_address;
      // 连接服务器超时时间，单位是毫秒
      dio.options.connectTimeout = 10 * 1000;
      // 接收数据的最长时限
      dio.options.receiveTimeout = 10 * 1000;

      /// 请求头
      String token = await UserManager.readToken();
      Map<String, String> header = _getHeader(token);
      dio.options.headers = header;

      HttpItem item = HttpItem();
      debugPrint('$url params: ' + params.toString());
      switch (method) {
        case Method.get:
          response = await dio.get(url, queryParameters: params);
          break;
        case Method.post:
          response = await dio.post(url, data: params);
          break;
        case Method.put:
          response = await dio.put(url, data: params);
          break;
        case Method.delete:
          response = await dio.delete(url, queryParameters: params);
          break;
      }

      //成功获取数据
      if (response.statusCode == 200) {
        Map<String, dynamic> body = response.data;
        item = HttpItem.fromJson(body);
        debugPrint('$url result: ' + convert.jsonEncode(body));
        if (item.code == 401) {
          // 重新登录
          onLogoutTap(context);
        }
        return item;
      } else {
        if (response.statusCode == 401) {
          onLogoutTap(context);
        }
        Map<String, dynamic> body = response.data;
        item = HttpItem.fromJson(body);
        item.code = response.statusCode;
        item.message = item.message;
        return item;
      }
    } catch (e) {
      debugPrint('$url error: ' + e.toString());
      HttpItem item = HttpItem();
      item.message = '请求失败';
      item.code = 0;
      item.data = {};
      return item;
    }
  }

  /// get请求
  static Future<HttpItem> get(String url, BuildContext context,
      {Map<String, dynamic>? params}) async {
    return HttpManager.sendRequest(url, Method.get, context, params ?? {});
  }

  /// post请求
  static Future<HttpItem> post(
      String url, Map<String, dynamic> params, BuildContext context) async {
    return HttpManager.sendRequest(url, Method.post, context, params);
  }

  /// put请求
  static Future<HttpItem> put(
      String url, Map<String, dynamic> params, BuildContext context) async {
    return HttpManager.sendRequest(url, Method.put, context, params);
  }

  /// delete请求
  static Future<HttpItem> delete(String url, BuildContext context,
      {Map<String, dynamic>? params}) async {
    return HttpManager.sendRequest(url, Method.delete, context, params ?? {});
  }

  /// 上传图片
  static Future<HttpItem> uploadImage(
      String url, Map<String, String> headers, dynamic body) async {
    //创建一个HttpClient
    HttpClient httpClient = new HttpClient();
    //打开Http连接
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
    //设置请求头
    headers.keys.forEach((key) {
      dynamic value = headers[key];
      request.headers.add(key, value);
    });
    //设置请求内容
    request.add(body);
    //等待连接服务器（会将请求信息发送给服务器）
    HttpClientResponse response = await request.close();
    //读取响应内容
    HttpItem item = HttpItem();
    //成功获取数据
    if (response.statusCode == 200) {
      item.data = url;
      item.code = response.statusCode;
      item.message = response.reasonPhrase;
    } else {
      item.data = null;
      item.code = response.statusCode;
      item.message = response.reasonPhrase;
    }
    //关闭client后，通过该client发起的所有请求都会中止。
    httpClient.close();
    return item;
  }

  static Map<String, String> _getHeader(String token) {
    Map<String, String> headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['clientType'] = Platform.isAndroid ? '1' : '2';
    if (token.isNotEmpty) {
      headers['Authorization'] = token;
    }
    debugPrint("header: " + headers.toString());
    return headers;
  }

  static void onLogoutTap(BuildContext context) async {
    String token = await UserManager.readToken();
    if (token.isNotEmpty) {
      UserManager.shared()!.logout();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }
}
