import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_medical_beauty/ui/login/login.dart';

import 'user.dart';

class NavigatorUtil {
  static void pushPage(BuildContext context, Widget page,
      {bool needLogin = true, bool fullscreenDialog = false}) async {
    bool isLogin = await UserManager.isLogin();
    if (needLogin && !isLogin) {
      Navigator.push(
          context,
          CupertinoPageRoute<void>(
              fullscreenDialog: true, builder: (ctx) => LoginScreen()));
      return;
    }

    Navigator.push(
        context,
        CupertinoPageRoute<void>(
            fullscreenDialog: fullscreenDialog, builder: (ctx) => page));
  }

  /// 高德地图
  static Future<bool> gotoAMap(context, longitude, latitude) async {
    var url =
        '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastHud.show(context, '未检测到高德地图~');
      return false;
    }

    await launch(url);

    return true;
  }

  /// 腾讯地图
  static Future<bool> gotoTencentMap(context, longitude, latitude) async {
    var url =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastHud.show(context, '未检测到腾讯地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 百度地图
  static Future<bool> gotoBaiduMap(context, longitude, latitude) async {
    var url =
        'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastHud.show(context, '未检测到百度地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 苹果地图
  static Future<bool> _gotoAppleMap(context, longitude, latitude) async {
    var url = 'http://maps.apple.com/?&daddr=$latitude,$longitude';

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastHud.show(context, '打开失败~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }
}
