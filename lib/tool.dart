import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/login/webview.dart';
import 'package:flutter_medical_beauty/ui/mine/member/open.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tool {
  /// target  要转换的数字
  /// position 要保留的位数
  /// isCrop  true 直接裁剪 false 四舍五入
  static String formatNum(num target, int position, {bool isCrop = false}) {
    String t = target.toString();
    // 如果要保留的长度小于等于0 直接返回当前字符串
    if (position < 0) {
      return t;
    }
    if (t.contains(".")) {
      String t1 = t.split(".").last;
      if (t1.length >= position) {
        if (isCrop) {
          // 直接裁剪
          return t.substring(0, t.length - (t1.length - position));
        } else {
          // 四舍五入
          return target.toStringAsFixed(position);
        }
      } else {
        // 不够位数的补相应个数的0
        String t2 = "";
        for (int i = 0; i < position - t1.length; i++) {
          t2 += "0";
        }
        return t + t2;
      }
    } else {
      // 不含小数的部分补点和相应的0
      String t3 = position > 0 ? "." : "";

      for (int i = 0; i < position; i++) {
        t3 += "0";
      }
      return t + t3;
    }
  }

  ///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
  /// 此方法中前三位格式有：
  /// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((12[0-9])|(13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      return '$day ${formatTime(hour)}:${formatTime(minute)}:${formatTime(second)}';
    } else if (hour != 0) {
      return '${formatTime(hour)}:${formatTime(minute)}:${formatTime(second)}';
    } else if (minute != 0) {
      return '00:${formatTime(minute)}:${formatTime(second)}';
    } else if (second != 0) {
      return '00:00:${formatTime(second)}';
    } else {
      return '--:--:--';
    }
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  /// 打开链接
  /// @url 打开的链接
  static void openUrl(BuildContext context, String url) async {
    if (url.isEmpty) {
      return;
    } else if (url == 'https://open/member') {
      bool isGrounding = await Tool.isGrounding();
      if (isGrounding == false) {
        NavigatorUtil.pushPage(context, OpenMemberScreen(), needLogin: true);
      }
    } else if (url.contains('https://goods/detail')) {
      Uri uri = Uri.parse(url);
      String? id = uri.queryParameters['id'];
      if (id != null && id != '') {
        NavigatorUtil.pushPage(context, DetailScreen(int.parse(id)));
      }
    } else {
      // 打开对应网址
      NavigatorUtil.pushPage(context, WebViewScreen(url), needLogin: false);
    }
  }

  /// 保存到本地
  static void saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /// 获取保存到本地的数据
  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  /// 保存到本地
  static void saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  /// 获取保存到本地的数据
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  /// 获取是否同意协议
  static Future<bool> isPrivacy() async {
    return await getBool('isAgree', defaultValue: Platform.isIOS);
  }

  /// 获取是否上架中
  static Future<bool> isGrounding() async {
    return await getBool('isGrounding', defaultValue: false);
  }
}
